# frozen_string_literal: true

require 'optparse'
require 'yaml'
require 'json'
require 'forwardable'
require 'logger'

# 錐彫の基底モジュール
#
# @author tk.hamaguchi@gmail.com
# @version 0.1.0
# @since   0.1.0
#
module Kiribori

  # 錐彫の基底エラー
  #
  # @author tk.hamaguchi@gmail.com
  # @version 0.1.0
  # @since   0.1.0
  #
  class Error < StandardError; end

  autoload :CLI,             'kiribori/cli'
  autoload :Server,          'kiribori/server'
  autoload :Option,          'kiribori/option'
  autoload :Logger,          'kiribori/logger'
  autoload :RackApp,         'kiribori/rack_app'
  autoload :SettingsParser,  'kiribori/settings_parser'
  autoload :TemplateBuilder, 'kiribori/template_builder'
  autoload :TemplateParser,  'kiribori/template_parser'
end

require 'kiribori/version'
