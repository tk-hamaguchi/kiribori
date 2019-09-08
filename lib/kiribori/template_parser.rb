# frozen_string_literal: true

module Kiribori

  # 錐彫テンプレートパーサー
  #
  # @author tk.hamaguchi@gmail.com
  # @version 0.1.0
  # @since   0.1.0
  #
  module TemplateParser

    module_function

    def parse!(template_name)
      template_path = fetch_template_path(template_name)
      File.read template_path
    end

    def fetch_template_path(template_name)
      File.expand_path "../../templates/#{template_name}.rb", __dir__
    end
  end
end
