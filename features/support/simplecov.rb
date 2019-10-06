# frozen_string_literal: true

require 'simplecov'
require 'codecov'

if ENV['COVERAGE'] || ENV['CI'] || ENV['CODECOV_TOKEN']
  SimpleCov.start do
    add_filter 'features'
    add_filter 'spec'
  end
  SimpleCov.command_name "Cucumber[#{Process.pid}]"
  SimpleCov.root(File.expand_path('../..', __dir__))
  SimpleCov.formatter = SimpleCov::Formatter::Codecov if ENV['CODECOV_TOKEN']
end

Before do
  set_environment_variable('CODECOV_TOKEN', ENV['CODECOV_TOKEN']) if ENV['CODECOV_TOKEN']
  set_environment_variable('COVERAGE', ENV['COVERAGE']) if ENV['COVERAGE']
  set_environment_variable('CI', ENV['CI']) if ENV['CI']
end
