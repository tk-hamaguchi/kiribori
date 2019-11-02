# language:ja

機能: CLIでのテンプレートビルド

シナリオ: テンプレートを指定しないビルド
  もし 下記のコマンドを実行する:
    """
    kiribori
    """
  ならば "標準エラー出力"に何も表示されていない
  かつ "標準出力"に下記のテンプレートが表示されている:
    |    テンプレート    | 含まれているか |
    | RailsBase          |       ○       |
    | MySQL Docker       |       ○       |
    | rubocop            |       ○       |
    | Config             |       ○       |
    | Dotenv             |       ○       |
    | sentry             |       ○       |
    | datadog            |       ○       |
    | Redis store        |       ○       |
    | HAML               |       ○       |
    | SimpleForm         |       ○       |
    | RSpec              |       ○       |
    | cucumber           |       ○       |
    | factory_bot        |       ○       |
    | annotate           |       ○       |
    | reek               |       ○       |
    | devise             |       ○       |
    | acts_as_paranoid   |       ○       |
    | kaminari           |       ○       |
    | pundit             |       ○       |
    | bootstrap4         |       ○       |
    | datatable          |       ○       |
    | RailsBestPractices |       ○       |
    | ERD                |       ○       |
    | docker             |       ○       |
    | nginx              |       ○       |
    | CircleCI           |       ×       |
    | app_scaffold       |       ×       |


シナリオ: テンプレートを指定したビルド
  もし 下記のコマンドを実行する:
    """
    kiribori --templates rails_base,mysql_docker
    """
  ならば "標準エラー出力"に何も表示されていない
  かつ "標準出力"に下記のテンプレートが表示されている:
    |    テンプレート    | 含まれているか |
    | RailsBase          |       ○       |
    | MySQL Docker       |       ○       |
    | rubocop            |       ×       |
    | Config             |       ×       |
    | Dotenv             |       ×       |
    | sentry             |       ×       |
    | datadog            |       ×       |
    | Redis store        |       ×       |
    | HAML               |       ×       |
    | SimpleForm         |       ×       |
    | RSpec              |       ×       |
    | cucumber           |       ×       |
    | factory_bot        |       ×       |
    | annotate           |       ×       |
    | reek               |       ×       |
    | devise             |       ×       |
    | acts_as_paranoid   |       ×       |
    | kaminari           |       ×       |
    | pundit             |       ×       |
    | bootstrap4         |       ×       |
    | datatable          |       ×       |
    | RailsBestPractices |       ×       |
    | ERD                |       ×       |
    | docker             |       ×       |
    | nginx              |       ×       |
    | CircleCI           |       ×       |
    | app_scaffold       |       ×       |


シナリオ: 全てのテンプレートを使ったビルド
  もし 下記のコマンドを実行する:
    """
    kiribori -a
    """
  ならば "標準エラー出力"に何も表示されていない
  かつ "標準出力"に下記のテンプレートが表示されている:
    |    テンプレート    | 含まれているか |
    | RailsBase          |       ○       |
    | MySQL Docker       |       ○       |
    | rubocop            |       ○       |
    | Config             |       ○       |
    | Dotenv             |       ○       |
    | sentry             |       ○       |
    | datadog            |       ○       |
    | Redis store        |       ○       |
    | HAML               |       ○       |
    | SimpleForm         |       ○       |
    | RSpec              |       ○       |
    | cucumber           |       ○       |
    | factory_bot        |       ○       |
    | annotate           |       ○       |
    | reek               |       ○       |
    | devise             |       ○       |
    | acts_as_paranoid   |       ○       |
    | kaminari           |       ○       |
    | pundit             |       ○       |
    | bootstrap4         |       ○       |
    | datatable          |       ○       |
    | RailsBestPractices |       ○       |
    | ERD                |       ○       |
    | docker             |       ○       |
    | nginx              |       ○       |
    | CircleCI           |       ○       |
    | app_scaffold       |       ○       |
