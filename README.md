# 錐彫(Kiribori)


```shell
kiribori-server
```
```shell
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


---


Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/kiribori`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kiribori'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kiribori

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/kiribori. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kiribori project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/kiribori/blob/master/CODE_OF_CONDUCT.md).
