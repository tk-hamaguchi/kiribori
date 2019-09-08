# frozen_string_literal: true

module Kiribori

  # 設定情報取り扱いモジュール
  #
  # @author tk.hamaguchi@gmail.com
  # @version 0.1.0
  # @since   0.1.0
  #
  module SettingsParser

    module_function

    def load
      unless const_defined?(:KIRIBORI_CONFIG)
        const_set :KIRIBORI_CONFIG, ::YAML.safe_load(File.read(settings_file), [], [], true, symbolize_names: true)
      end
      const_get :KIRIBORI_CONFIG
    end

    def settings_file
      File.expand_path('../../config/settings.yml', __dir__)
    end
  end
end
