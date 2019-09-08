# frozen_string_literal: true

module Kiribori

  # コマンドラインインターフェース
  #
  # @author tk.hamaguchi@gmail.com
  # @version 0.1.0
  # @since   0.1.0
  #
  class CLI
    autoload :Executor,     'kiribori/cli/executor'
    autoload :OptionParser, 'kiribori/cli/option_parser'

    attr_reader :options, :target

    def initialize
      @options = {}
      @target  = []
      @config  = Kiribori::SettingsParser.load
    end

    class << self
      def execute!(argv)
        cli = new
        cli.parse(argv)
        cli.execute!
      end
    end

    include OptionParser
    include Executor
  end
end
