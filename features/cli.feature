# language:ja

機能: CLI

シナリオ:
  もし 下記のコマンドを実行する:
    """
    kiribori --templates rails_base,mysql_docker
    """
  ならば "標準エラー出力"に何も表示されていない
  ならば "標準出力"に下記の内容が表示されている:
    """
    hoge
    """