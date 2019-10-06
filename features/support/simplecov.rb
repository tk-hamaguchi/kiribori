# frozen_string_literal: true

require 'simplecov'

if ENV['COVERAGE'] || ENV['CI']
  SimpleCov.start do
    add_filter 'features'
    add_filter 'spec'
  end
end
