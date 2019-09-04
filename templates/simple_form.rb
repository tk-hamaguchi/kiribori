# frozen_string_literal: true

gem 'simple_form'

Open3.capture3('bundle install')

generate 'simple_form:install', '--bootstrap'
