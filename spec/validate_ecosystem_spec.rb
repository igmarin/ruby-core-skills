# frozen_string_literal: true
require 'minitest/autorun'
require 'tmpdir'
require 'fileutils'
require 'open3'
require 'rbconfig'

class ValidateEcosystemTest < Minitest::Test
  def test_clean_checkout_validates_without_sibling_repositories
    Dir.mktmpdir do |root|
      source = File.expand_path('..', __dir__)
      %w[scripts skills directory.json].each { |name| FileUtils.cp_r(File.join(source, name), root) }
      output, status = Open3.capture2e(RbConfig.ruby, File.join(root, 'scripts/validate-ecosystem.rb'))
      assert status.success?, output
      assert_includes output, 'Local pack only'
      FileUtils.rm(File.join(root, 'skills/triage-bug/SKILL.md'))
      output, status = Open3.capture2e(RbConfig.ruby, File.join(root, 'scripts/validate-ecosystem.rb'))
      refute status.success?, output
      assert_includes output, 'missing SKILL.md'
    end
  end
end
