# language:ja

機能: サーバーでのテンプレートビルド

シナリオ: テンプレートを指定しないビルド
  もし 下記のパスにGETメソッドでアクセスする:
    """
    /
    """
  ならば ステータスコード"200"が返る
  かつ Content-Typeが"application/x-thor-template"である
  かつ レスポンスボディに下記のテンプレートが表示されている:
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
  もし 下記のパスにGETメソッドでアクセスする:
    """
    /?templates=rails_base,mysql_docker
    """
  ならば ステータスコード"200"が返る
  かつ Content-Typeが"application/x-thor-template"である
  かつ レスポンスボディに下記のテンプレートが表示されている:
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


シナリオ: テンプレートを除外したビルド
  もし 下記のパスにGETメソッドでアクセスする:
    """
    /?without=datatable,bootstrap4
    """
  ならば ステータスコード"200"が返る
  かつ Content-Typeが"application/x-thor-template"である
  かつ レスポンスボディに下記のテンプレートが表示されている:
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
    | bootstrap4         |       ×       |
    | datatable          |       ×       |
    | RailsBestPractices |       ○       |
    | ERD                |       ○       |
    | docker             |       ○       |
    | nginx              |       ○       |
    | CircleCI           |       ×       |
    | app_scaffold       |       ×       |


シナリオ: 全てのテンプレートを使ったビルド
  もし 下記のパスにGETメソッドでアクセスする:
    """
    /all
    """
  ならば ステータスコード"200"が返る
  かつ Content-Typeが"application/x-thor-template"である
  かつ レスポンスボディに下記のテンプレートが表示されている:
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


シナリオ: 存在しないテンプレートを指定したビルド
  もし 下記のパスにGETメソッドでアクセスする:
    """
    /?templates=hoge
    """
  ならば ステータスコード"500"が返る
  かつ Content-Typeが"text/plain"である
  かつ レスポンスボディに下記の文字列が含まれている:
    """
    No such file or directory
    """
