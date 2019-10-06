# frozen_string_literal: true

require 'capybara/cucumber'

require 'kiribori'

Capybara.app = Kiribori::RackApp.new
