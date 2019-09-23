# frozen_string_literal: true

class Kiribori::CLI

  # コマンドラインインターフェース用メインロジック
  #
  # @author tk.hamaguchi@gmail.com
  # @version 0.1.0
  # @since   0.1.0
  #
  module Executor
    def execute!
      select_templates.each_with_object([template_prefix]) do |template_name, ary|
        ary << Kiribori::TemplateParser.parse!(template_name)
      end.join("\n#----\n\n")
    end

    def template_prefix
      <<~TEMPLATE
        # encoding: UTF-8
        # frozen_string_literal: true

        def source_paths
          [Rails.root]
        end

        def app_class
          app_name.camelize.constantize.const_get(:Application)
        end

        ENV['DISABLE_SPRING'] = '1'
        ENV['BUNDLE_IGNORE_MESSAGES'] = '1'
      TEMPLATE
    end

    def select_templates
      if options[:all]
        @config[:templates][:all]
      else
        options[:templates].split ','
      end
    end
  end
end
