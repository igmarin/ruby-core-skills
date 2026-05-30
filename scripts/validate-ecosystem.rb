#!/usr/bin/env ruby
# frozen_string_literal: true

# Ecosystem Integrity Validator
# Run from a directory containing all 6 repos as siblings, or from the root of the workspace.

require 'json'
require 'yaml'
require 'pathname'

class EcosystemValidator

  def initialize
    @workspace_root = File.expand_path('../..', __dir__)
    @registry_path = File.join(@workspace_root, 'agent-mcp-runtime', 'registry.json')
  end

  def validate
    unless File.exist?(@registry_path)
      puts "FAIL: registry.json not found at #{@registry_path}"
      exit 1
    end

    begin
      @registry = JSON.parse(File.read(@registry_path))
      @packs = @registry['packs'] || {}
    rescue JSON::ParserError, IOError => e
      puts "FAIL: Error reading or parsing registry.json at #{@registry_path}: #{e.message}"
      exit 1
    end

    @repos_info = {}
    @packs.each do |pack_name, pack_config|
      repo_name = pack_config['source'].split('/').last
      repo_path = File.join(@workspace_root, repo_name)
      unless Dir.exist?(repo_path)
        puts "FAIL: Sibling repository #{repo_name} does not exist at #{repo_path}"
        exit 1
      end
      @repos_info[pack_name] = {
        name: pack_config['source'],
        path: repo_path,
        tile_path: File.join(repo_path, pack_config['tile'] || '.tessl-plugin/plugin.json')
      }
    end

    # Load plugin manifest for each repository
    @repos_info.each do |pack_name, repo_info|
      unless File.exist?(repo_info[:tile_path])
        puts "FAIL: plugin manifest not found for #{pack_name} at #{repo_info[:tile_path]}"
        exit 1
      end
      repo_info[:tile] = JSON.parse(File.read(repo_info[:tile_path]))
    end

    errors = []

    # Check 1: Every declared skill has a directory with SKILL.md
    puts "--- Check 1: Skill Directories and SKILL.md ---"
    errors += validate_skill_directories

    # Check 2: depends_on repos exist
    puts "\n--- Check 2: Pack Dependencies ---"
    errors += validate_dependencies

    # Check 3: No skill name collision within a pack stack
    puts "\n--- Check 3: Skill Key Uniqueness in Pack Stack ---"
    errors += validate_no_collisions

    # Check 4: Agent dependency declarations are resolvable
    puts "\n--- Check 4: Agent Dependencies Resolution ---"
    errors += validate_agent_dependencies

    # Check 5: registry.json packs all resolve
    puts "\n--- Check 5: registry.json Manifest Consistency ---"
    errors += validate_registry_manifest

    puts "\n========================================="
    if errors.empty?
      puts "AUDIT STATUS: PASS"
      exit 0
    else
      puts "AUDIT STATUS: FAIL"
      errors.each { |e| puts "✗ #{e}" }
      exit 1
    end
  end

  private

  def skill_dirs_from_manifest(tile, repo_path)
    skills = tile['skills'] || []
    case skills
    when String
      Dir.glob("**/SKILL.md", base: File.join(repo_path, skills)).map { |p| File.join(skills, File.dirname(p)) }
    when Array
      skills.map { |s| s.sub(%r{^\./}, '') }
    else
      []
    end
  end

  def skill_names_from_manifest(tile, repo_path)
    skill_dirs_from_manifest(tile, repo_path).map { |d| File.basename(d) }
  end

  def validate_skill_directories
    errors = []
    @repos_info.each do |pack_name, repo_info|
      tile = repo_info[:tile]
      dirs = skill_dirs_from_manifest(tile, repo_info[:path])
      dirs.each do |dir|
        skill_path = File.join(repo_info[:path], dir, 'SKILL.md')
        unless File.exist?(skill_path)
          errors << "Skill directory '#{dir}' in pack '#{pack_name}' is missing SKILL.md"
        end
      end
    end
    errors
  end

  def validate_dependencies
    errors = []
    @packs.each do |pack_name, pack_config|
      depends_on = pack_config['depends_on'] || []
      depends_on.each do |dep_pack|
        unless @packs.key?(dep_pack)
          errors << "Pack '#{pack_name}' in registry depends on unknown pack '#{dep_pack}'"
        end
      end
    end
    errors
  end

  def resolve_stack(pack_name, visited = [])
    return [] if visited.include?(pack_name)
    visited = visited + [pack_name]

    pack_config = @packs[pack_name]
    return [] unless pack_config

    stack = [pack_name]
    depends_on = pack_config['depends_on'] || []
    depends_on.each do |dep_pack|
      stack += resolve_stack(dep_pack, visited)
    end
    stack.uniq
  end

  def validate_no_collisions
    errors = []
    @packs.each_key do |pack_name|
      stack = resolve_stack(pack_name)
      skill_to_repo = {}
      stack.each do |stack_pack|
        repo_info = @repos_info[stack_pack]
        next unless repo_info

        names = skill_names_from_manifest(repo_info[:tile], repo_info[:path])
        names.each do |skill_name|
          if skill_to_repo.key?(skill_name)
            errors << "Skill '#{skill_name}' is defined in both '#{stack_pack}' (#{repo_info[:name]}) and '#{skill_to_repo[skill_name]}'"
          else
            skill_to_repo[skill_name] = stack_pack
          end
        end
      end
    end
    errors
  end

  def validate_agent_dependencies
    errors = []
    @repos_info.each do |pack_name, repo_info|
      agents_json_path = File.join(repo_info[:path], 'agents.json')
      next unless File.exist?(agents_json_path)

      begin
        agents_data = JSON.parse(File.read(agents_json_path))
      rescue StandardError => e
        errors << "Failed to parse agents.json for '#{pack_name}': #{e.message}"
        next
      end

      agents = agents_data['agents'] || {}
      agents.each do |agent_name, agent_info|
        agent_path = File.join(repo_info[:path], agent_info['path'])
        unless File.exist?(agent_path)
          puts "Checking Agent"; errors << "Agent '#{agent_name}' in '#{pack_name}' has missing SKILL.md at #{agent_path}"
          next
        end

        content = File.read(agent_path)
        match = content.match(/\A---\s*\n(.*?)\n---/m)
        unless match
          puts "Checking Agent"; errors << "Agent '#{agent_name}' in '#{pack_name}' has no YAML front-matter in SKILL.md"
          next
        end

        begin
          front_matter = YAML.safe_load(match[1])
        rescue StandardError => e
          puts "Checking Agent"; errors << "Agent '#{agent_name}' in '#{pack_name}' has invalid YAML front-matter: #{e.message}"
          next
        end

        metadata = front_matter['metadata'] || {}
        dependencies = metadata['dependencies'] || []
        if dependencies.is_a?(Array)
          dependencies.each_with_index do |dep, idx|
            unless dep.is_a?(Hash)
              errors << "Agent '#{agent_name}' in '#{pack_name}' has malformed dependency at index #{idx}: #{dep.inspect}"
              next
            end
            source = dep['source']
            skills = dep['skills'] || []

            target_repo_info = nil
            if source == 'self' || source == repo_info[:name] || source == pack_name
              target_repo_info = repo_info
            else
              target_repo_info = @repos_info.values.find { |r| r[:name] == source || r[:name].split('/').last == source.split('/').last }
            end

            if target_repo_info.nil?
              puts "Checking Agent"; errors << "Agent '#{agent_name}' in '#{pack_name}' depends on unknown source '#{source}'"
              next
            end

            target_names = skill_names_from_manifest(target_repo_info[:tile], target_repo_info[:path])
            skills.each do |skill_name|
              unless target_names.include?(skill_name)
                puts "Checking Agent"; errors << "Agent '#{agent_name}' in '#{pack_name}' depends on skill '#{skill_name}' from '#{source}', but it is not defined in that source's plugin manifest"
              end
            end
          end
        else
          puts "Checking Agent"; errors << "Agent '#{agent_name}' in '#{pack_name}' has invalid 'dependencies' in YAML front-matter (must be a list)"
        end
      end
    end
    errors
  end

  def validate_registry_manifest
    errors = []
    default_stack = @registry['default_stack'] || []
    default_stack.each do |pack|
      unless @packs.key?(pack)
        errors << "Default stack pack '#{pack}' is not defined in packs list"
      end
    end
    errors
  end
end

EcosystemValidator.new.validate if __FILE__ == $PROGRAM_NAME
