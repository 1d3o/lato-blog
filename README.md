# Lato Blog

## Installation

Add the lato_blog gem on your Gemfile

```ruby
gem 'lato_blog'
```

Install the gem

```console
bundle install
```

Copy the migrations

```console
rails lato_blog:install:migrations
```

Exec migrations

```console
bundle exec rake db:migrate
```
