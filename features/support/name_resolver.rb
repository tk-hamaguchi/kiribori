# frozen_string_literal: true

# シナリオの表記名を変換するモジュール
#
# @author tk.hamaguchi@gmail.com
# @version 0.1.0
# @since   0.1.0
#
module NameResolver

  # 標準出力・標準エラー出力をマッチャーに変換する
  #
  # @param [String] output 標準出力・標準エラー出力の表記
  # @return [Symbol] 入力名に対応するhave_outputマッチャー
  #
  # @see https://github.com/cucumber/aruba
  #
  def output_to_matcher(output)
    case output
    when '標準出力', 'stdout', 'STDOUT' then :have_output_on_stdout
    when '標準エラー出力', 'stderr', 'STDERR' then :have_output_on_stderr
    else
      :have_output
    end
  end
end

World NameResolver
