# frozen_string_literal: true

class Kiribori::CLI

  # コマンドラインインターフェース用オプションパーサー
  #
  # @author tk.hamaguchi@gmail.com
  # @version 0.1.0
  # @since   0.1.0
  #
  module OptionParser
    def parse(argv)
      opt = ::OptionParser.new
      opt.on('-a', '--all') { |v| v }
      opt.on('-t', '--templates=VAL') { |v| v }
      opt.parse!(argv, into: options)
    end
  end
end
