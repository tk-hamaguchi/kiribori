# frozen_string_literal: true

require 'optparse'
require 'yaml'

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

  autoload :CLI, 'kiribori/cli'
  autoload :SettingsParser, 'kiribori/settings_parser'
  autoload :TemplateParser, 'kiribori/template_parser'
end

require 'kiribori/version'
