# frozen_string_literal: true

class Kiribori::Server

  # サーバー用ロガー
  #
  # @author tk.hamaguchi@gmail.com
  # @version 0.1.0
  # @since   0.1.0
  #
  module Logger
    def logger
      @logger ||= Kiribori::Logger.new(@option.log_path)
    end
  end
end
