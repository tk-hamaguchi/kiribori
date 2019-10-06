# frozen_string_literal: true

module Kiribori

  # サーバーインターフェース
  #
  # @author tk.hamaguchi@gmail.com
  # @version 0.1.0
  # @since   0.1.0
  #
  class Server
    autoload :RequestParser, 'kiribori/server/request_parser'
    autoload :Executor,      'kiribori/server/executor'
    autoload :Logger,        'kiribori/server/logger'

    class << self
      def execute!(env)
        server = new
        server.parse(env)
        server.execute!
      end
    end

    include RequestParser
    include Executor
    include Logger
  end
end
