# 錐彫(Kiribori)

[![codecov](https://codecov.io/gh/tk-hamaguchi/kiribori/branch/master/graph/badge.svg)](https://codecov.io/gh/tk-hamaguchi/kiribori)


Railsテンプレートを取捨選択しながら生成するテンプレートジェネレータ


## インストール

```shell
gem install kiribori --source 'https://rubygems.pkg.github.com/tk-hamaguchi'
```


## 使い方

### HTTP経由で使う

1. KiriboriをServerモードで起動する

```shell
kiribori-server
```

2. rails newした後で `rails app:template LOCATION='http://localhost:9292'` を実行する
```shell
bundle exec rails app:template LOCATION='http://localhost:9292'
```


### テンプレートファイルを作成して使う

1. Kiriboriをファイルモードで起動する

```shell
kiribori > template.rb
```

2. rails newした後で `rails app:template LOCATION='../template.rb'` を実行する
```shell
bundle exec rails app:template LOCATION='../template.rb'
```


## デフォルトで適用されるテンプレート

|    テンプレート    |    テンプレート名    | テンプレートの差分 |
|:-------------------|:--------------------:|:--------------------:|
| RailsBase          | rails_base           | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/a0327bbfc5b5ae34bff7f2f26aac926fee889c0b) |
| MySQL Docker       | mysql_docker         | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/75d33e53f2ace0b6eca1e6ce2a935d3e708edbe3) |
| rubocop            | rubocop              | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/8e3f0117f7e196671f51731dfd566c622283328a) |
| Config             | config               | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/8567af744b35269412f5179b648375658776d89a) |
| Dotenv             | dotenv               | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/4e1ab9ba378b16a7200971fd2b373a80fc40fd06) |
| Redis store        | redis_store          | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/dac3844ea90a1a99783623a63ddb2c1271df9cae) |
| HAML               | haml-rails           | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/b8020aa98ae974cbb3649eeebdcc765cd3db3cac) |
| SimpleForm         | simple_form          | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/8abfd1f40d539725c69ab0e933738eb87f4be052) |
| RSpec              | rspec                | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/85aaa48d83ccc2ffebcb41162c818c387554d85f) |
| cucumber           | cucumber             | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/c5f25ae27fd84f390dbb0410724f92d3ef9f7906) |
| factory_bot        | factory_bot          | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/e4623ad63a683db8a67942f0c1c24a8b34e67ff9) |
| annotate           | annotate             | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/7d20260c59590928845cc28f738c45c512f886df) |
| reek               | reek                 | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/66107c4f9ce21f9c498f44e87becde3a21c75d0c) |
| devise             | devise               | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/76be7fef8978b0ad26976768a80fe6207fb03ca3) |
| acts_as_paranoid   | acts_as_paranoid     | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/a9fddc5dbc4af50d3afdc78ada66512912b58371) |
| kaminari           | kaminari             | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/7cd1e91fa458b3b93369e0ef782eb107990b924e) |
| pundit             | pundit               | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/f94795320a12997080d51a767e176823cb401851) |
| bootstrap4         | bootstrap4           | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/ceb8215a63711d487bc27fce8e761ba03ed2b227) |
| datatable          | datatable            | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/fd6881929cf69473cf61f12e6c97a3eb71e227b4) |
| RailsBestPractices | rails_best_practices | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/8fe224f0eb3f0304d491da203a96ce44af21fc9e) |
| ERD                | erd                  | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/198f61b2e2f9bea831c0c3c9c67aa653fe7528e1) |
| docker             | docker               | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/b6f9fe4ca59a179a347a68593cdc9eac949e456b) |


## GETTING STARTED 

```shell
kiribori-server &
gem install bundler rails --no-document
rails new kiribori_sample \
    --database=mysql \
    --skip-action-mailbox \
    --skip-test --skip-system-test \
    --skip-action-text \
    --skip-active-storage \
    --skip-action-cable \
    --webpack=vue
cd kiribori_sample
git init
git add .
git commit -m 'kiribori_sample'
bundle exec rails app:template LOCATION='http://localhost:9292'
```

## Contributing

TBD

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kiribori project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/tk-hamaguchi/kiribori/blob/master/CODE_OF_CONDUCT.md).
