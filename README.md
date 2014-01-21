# Overview

[![Gem Version](https://badge.fury.io/rb/auther.png)](http://badge.fury.io/rb/auther)
[![Code Climate GPA](https://codeclimate.com/github/bkuhlmann/auther.png)](https://codeclimate.com/github/bkuhlmann/auther)
[![Travis CI Status](https://secure.travis-ci.org/bkuhlmann/auther.png)](http://travis-ci.org/bkuhlmann/auther)

Provides simple, form-based authentication for apps that need security but don't want to deal with the clunky UI
of HTTP Basic Authentication or something as heavyweight as [Devise](https://github.com/plataformatec/devise). It
doesn't require a database and is compatible with password managers like [1Password](https://agilebits.com/onepassword)
making for a pleasent user experience.

# Features

* Form-based authentication compatible with password managers like [1Password](https://agilebits.com/onepassword).

[![Screenshot](https://github.com/bkuhlmann/auther/raw/master/screenshot.png)](https://github.com/bkuhlmann/auther)

* Encrypted account credentials.
* Multiple account support with account specific blacklisted paths.
* Auto-redirection to requested path (once credentials have been verified).
* Customizable view.
* Customizable controller.

# Requirements

0. [Ruby 2.x.x](http://www.ruby-lang.org).
0. [Ruby on Rails 4.x.x](http://rubyonrails.org).

# Setup

For a secure install, type the following from the command line (recommended):

    gem cert --add <(curl -Ls http://www.redalchemist.com/gem-public.pem)
    gem install auther -P HighSecurity

...or, for an insecure install, type the following (not recommended):

    gem install auther

Add the following to your Gemfile:

    gem "auther"

Edit your routes.rb as follows:

    Rails.application.routes.draw do
      mount Auther::Engine => "/auther"
      get "/login", to: "auther/session#new"
    end

Edit your application.rb as follows:

    module Example
      class Application < Rails::Application

        config.auther_settings = {
          title: "Authorization",
          label: "Authorization",
          accounts: [
            name: "admin",
            login: "N3JzR213WlBISDZsMjJQNkRXbEVmYVczbVdnMHRYVHRud29lOWRCekp6ST0tLWpFMkROekUvWDBkOHZ4ZngxZHV6clE9PQ==--cd863c39991fa4bb9a35de918aa16da54514e331",
            password: "cHhFSStjRm9KbEYwK3ZJVlF2MmpTTWVVZU5acEdlejZsZEhjWFJoQWxKND0tLTE3cmpXZVBQdW5VUW1jK0ZSSDdLUnc9PQ==--f51171174fa77055540420f205e0dd9d499cfeb6",
            paths: ["/admin"]
          ],
          secret: "vuKrwD9XWoYuv@s99?tR(9VqryiL,KV{W7wFnejUa4QcVBP+D{2rD4JfuD(mXgA=$tNK4Pfn#NeGs3o3TZ3CqNc^Qb",
          auth_url: "/login"
        }

      end
    end

NOTE: The decrypted account credentials, for example above, are as follows:

* login: test@test.com
* password: password

# Usage

Using the setup examples, from above, launch your Rails application and visit either of the following routes:

    http://localhost:3000/login
    http://localhost:3000/admin # Will redirect to /login if not authorized.

To encrypt/decrypt account credentials, launch a rails console and type the following:

    # Best if more than 150 characters and gibberish to read. Must be the same as defined in auther settings.
    cipher = Auther::Cipher.new "vuKrwD9XWoYuv@s99?tR(9VqryiL,KV{W7wFnejUa4QcVBP+D{2rD4JfuD(mXgA=$tNK4Pfn#NeGs3o3TZ3CqNc^Qb"

    # Do this to encrypt an unecrypted value.
    cipher.encrypt "test@test.com"

    # Do this to decrypt an encrypted value.
    cipher.decrypt "N3JzR213WlBISDZsMjJQNkRXbEVmYVczbVdnMHRYVHRud29lOWRCekp6ST0tLWpFMkROekUvWDBkOHZ4ZngxZHV6clE9PQ==--cd863c39991fa4bb9a35de918aa16da54514e331"

# Customization

## Model

The [Auther::Account](app/models/auther/account.rb) is a plain old Ruby object that uses ActiveRecord validations
to aid in form/credential validation. This model could potentially be replaced with a database-backed object
(would require controller customization)...but you might want to question if you have outgrown the use of this
gem and need a different solution altogether.

## Views

The view can be customized by creating the following file within your Rails application (assumes that the
default Auther::SessionController implementation is sufficient):

    app/views/auther/session/new.html

The form can also be customized by attaching new styles to the .authorization class (see
[auther.scss](app/assets/stylesheets/auther/auther.scss) for details).

## Controller

The [Auther::SessionController](app/controllers/auther/session_controller.rb) inherits from the
[Auther::BaseController](app/controllers/auther/base_controller.rb). To customize, it is recommended that
you add a controller to your app that inherit from the Auther::BaseController. Example:

    # Example Path:  app/controllers/session_controller.rb
    class SessionController < Auther::BaseController
      layout "example_site_layout"
    end

This allows complete customization of session controller behavior to serve any special business needs. See the
Auther::BaseController for additional details or the Auther::SessionController for default implementation.

## Routes

As mentioned in the setup above, the routes can also be customized. Example:

    Rails.application.routes.draw do
      mount Auther::Engine => "/auther"
      get "/login", to: "auther/session#new"
      delete "/logout", to: "auther/session#destroy"
    end

# Tests

To test, do the following:

0. cd to the gem root.
0. bundle install
0. bundle exec rspec spec

# Resources

* [Simplest Auth](https://github.com/vigetlabs/simplest_auth) - For situations where you need user and email reset
  support beyond what this engine can provide.

# Contributions

Read CONTRIBUTING for details.

# Credits

Developed by [Brooke Kuhlmann](http://www.redalchemist.com) at [Red Alchemist](http://www.redalchemist.com).

# License

Copyright (c) 2014 [Red Alchemist](http://www.redalchemist.com).
Read the LICENSE for details.

# History

Read the CHANGELOG for details.
Built with [Gemsmith](https://github.com/bkuhlmann/gemsmith).
