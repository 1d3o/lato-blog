# Lato Blog

[![Gem Version](https://badge.fury.io/rb/lato_blog.svg)](https://badge.fury.io/rb/lato_blog)

Lato is a Rails engine used to develop modular admin panels. This is the module used to manage a blog.

## Installation

Install [lato_core](https://github.com/ideonetwork/lato-core) and [lato_media](https://github.com/ideonetwork/lato-media) gem as required dependencies.

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

## TODO

Update lato_media version to avoid security vulnerabilities when a new lato_media version is online and publish update on rubygems.
