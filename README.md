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
| RailsBase          | rails_base           | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/85362ffeff6170bba2184ca1e6049291f4b43e4e) |
| MySQL Docker       | mysql_docker         | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/5188eb2e97e6de8004fb300d910df2fb40ca4a72) |
| rubocop            | rubocop              | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/acd0e39dee8fdc576b693e007bc0889e6ad95718) |
| Config             | config               | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/7dc13928cd435da783a3c84192850e75f34b5534) |
| Dotenv             | dotenv               | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/ff7da7d2b3ac3a41038ffc127246570393c9bf98) |
| Sentry             | sentry               | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/9dc29a1b24e9b99f70911d85160381fd336e0ba3) |
| DataDog            | datadog              | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/d1f7eb922694ba7c46bfbb49adb7c0b360d829db) |
| Redis store        | redis_store          | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/124c18e75d72e8601f46301e6d6e1b9a60103bf0) |
| HAML               | haml-rails           | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/e3cbb78e3ef7a788de31d4d72028a3db85419deb) |
| SimpleForm         | simple_form          | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/b19b208218a69659e739d89f05529c9368eb2ade) |
| RSpec              | rspec                | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/8e0fb3be9f4edca682c3b1b8163d5b08c9acce34) |
| cucumber           | cucumber             | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/b3aea773455e823b521ef3235e5b0d4093613f31) |
| factory_bot        | factory_bot          | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/6932907f9ad9b93829085629c1cca9cc4def7196) |
| annotate           | annotate             | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/d26a71bef1ca42e26b37a708390e6e764933c74d) |
| reek               | reek                 | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/5d861e6bd3a0b0af81a0027cc4be3043845abdc2) |
| devise             | devise               | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/3c0175f5c2bcd4ab3cf9ace9906691a3d96a40f7) |
| acts_as_paranoid   | acts_as_paranoid     | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/b5b17341fc0648d8fc32afca17fcb5acfa9d3077) |
| kaminari           | kaminari             | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/f267b27ac6c5948fdaa660b53ea4363eb68183c4) |
| pundit             | pundit               | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/e2c3c9345057e37bf44eaf9d8bd909a8a0fa1b3c) |
| bootstrap4         | bootstrap4           | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/f2d494c3ee92934d565432aef237894ecb704080) |
| datatable          | datatable            | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/e5d8b0bc4751e20d28a2695cf19cf085c5cb30ff) |
| RailsBestPractices | rails_best_practices | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/9ce79a6213bc7322ad4f0432d4544d55de53d2fd) |
| ERD                | erd                  | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/12fb0d7040f6d42f1682cf16abc905dd46fb40f9) |
| docker             | docker               | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/3b81ddb1616d6cc681504887e2a0c04a13bc1db7) |
| Nginx Docker       | nginx                | [diff](https://github.com/tk-hamaguchi/kiribori_sample/commit/85e89ac04039186c8a2f8d9773ff895ff727f9fc) |


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
