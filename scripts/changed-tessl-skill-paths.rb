#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "set"

ROOT = File.expand_path("..", __dir__)
plugin = JSON.parse(File.read(File.join(ROOT, ".tessl-plugin", "plugin.json")))
publishable_paths = plugin.fetch("skills")
changed_files = STDIN.read.lines.map(&:strip).reject(&:empty?)

changed_skill_paths = publishable_paths.select do |skill_path|
  clean_skill_path = skill_path.sub(/\A\.\//, "")
  skill_dir = File.dirname(clean_skill_path)
  changed_files.any? { |path| path == clean_skill_path || path.start_with?("#{skill_dir}/") }
end

puts changed_skill_paths.join("\n")
