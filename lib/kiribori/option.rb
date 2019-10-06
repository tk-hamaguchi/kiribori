# frozen_string_literal: true

module Kiribori

  # オプション
  #
  # @author tk.hamaguchi@gmail.com
  # @version 0.1.0
  # @since   0.1.0
  #
  class Option
    attr_reader :config
    attr_reader :templates
    attr_reader :log_path

    def initialize(all: true, templates: [], without: [], group: nil, config: nil)
      without = without.is_a?(String) ? without.split(',') : without

      @config    = config || SettingsParser.load
      @templates = select_template(all: all, templates: templates, group: group) - without
    end

    def select_template(all:, templates:, group:)
      if !templates.empty?
        templates.is_a?(Array) ? templates : templates.split(',')
      elsif all
        @config[:templates][:all]
      elsif group
        @config[:templates][group]
      else
        @config[:templates][:default]
      end
    end
  end
end
