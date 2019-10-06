# frozen_string_literal: true

module Kiribori

  # テンプレートビルダー
  #
  # @author tk.hamaguchi@gmail.com
  # @version 0.1.0
  # @since   0.1.0
  #
  class TemplateBuilder

    class << self
      def build!(templates)
        templates.each_with_object([template_prefix]) do |template_name, ary|
          ary << Kiribori::TemplateParser.parse!(template_name)
        end.join("\n#----\n\n")
      end

      private

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
    end
  end
end
