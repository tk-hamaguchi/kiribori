# frozen_string_literal: true

module Kiribori

  # ロガー
  #
  # @author tk.hamaguchi@gmail.com
  # @version 0.1.0
  # @since   0.1.0
  #
  class Logger
    extend Forwardable

    def initialize(path = nil)
      if path
        @std_logger = @err_logger = ::Logger.new(path)
      else
        @std_logger = ::Logger.new(STDOUT)
        @err_logger = ::Logger.new(STDERR)
      end
    end

    def_instance_delegators :@std_logger, :info, :debug
    def_instance_delegators :@err_logger, :warn, :error, :fata
  end
end
