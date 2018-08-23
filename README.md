# AppBuilder::Rails

Generate application to be deployed and upload to s3 (or deploy server).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "app_builder-rails"
```

And then execute:

```
$ bundle install
$ bundle exec rails generate app_builder:install
```

Adds following files:

- `config/deploy/environment.yml`
- `config/deploy/templates/manifest.yml.erb`
- `lib/tasks/deploy.rake`

## Usage

Build source and upload to S3:

```
$ APP_ENV=develop TARGET_BRANCH=develop bundle exec rails deploy:prepare
INFO    2018-01-01 12:00:00.000000  9999    Execute command [local]: mkdir -p /var/tmp/project /var/tmp/project/archive/20180101120000 /var/tmp/project/build/20180101120000
INFO    2018-01-01 12:00:00.000000  9999    Execute command [local]: git remote update (with: {:chdir=>"/var/tmp/project/repo"})
INFO    2018-01-01 12:00:00.000000  9999    Execute command [local]: git archive develop | tar -x -C /var/tmp/project/archive/20180101120000 (with: {:chdir=>"/var/tmp/project/repo"})
INFO    2018-01-01 12:00:00.000000  9999    Create revision: {"branch"=>"develop", "revision"=>"0123456789abcdef0123456789abcdef0123456"}
INFO    2018-01-01 12:00:00.000000  9999    Execute command [local]: tar zcf /var/tmp/project/build/20180101120000/20180101120000.tar.gz . (with: {:chdir=>"/var/tmp/project/archive/20180101120000"})
INFO    2018-01-01 12:00:00.000000  9999    Uploaded /var/tmp/project/build/20180101120000/20180101120000.tar.gz to s3://dev-source-example-com/assets/20180101120000.tar.gz
INFO    2018-01-01 12:00:00.000000  9999    Uploaded /var/tmp/project/build/20180101120000/20180101120000.yml to s3://dev-source-example-com/manifests/20180101120000.yml
```

And then deploy with stretcher in target server:

```
$ ssh target-server
$ echo s3://dev-source-example-com/manifests/20180101120000.yml | stretcher
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/i2bskn/app_builder-rails.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
