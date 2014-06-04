# Overview

[![Gem Version](https://badge.fury.io/rb/auther.png)](http://badge.fury.io/rb/auther)
[![Code Climate GPA](https://codeclimate.com/github/bkuhlmann/auther.png)](https://codeclimate.com/github/bkuhlmann/auther)
[![Gemnasium Status](https://gemnasium.com/bkuhlmann/auther.png)](https://gemnasium.com/bkuhlmann/auther)
[![Travis CI Status](https://secure.travis-ci.org/bkuhlmann/auther.png)](http://travis-ci.org/bkuhlmann/auther)
[![Coverage Status](https://coveralls.io/repos/bkuhlmann/auther/badge.png)](https://coveralls.io/r/bkuhlmann/auther)

Provides simple, form-based authentication for apps that need security but don't want to deal with the clunky UI
of HTTP Basic Authentication or something as heavyweight as [Devise](https://github.com/plataformatec/devise). It
doesn't require a database and is compatible with password managers like [1Password](https://agilebits.com/onepassword)
making for a pleasent user experience.

# Features

* Form-based authentication compatible with password managers like [1Password](https://agilebits.com/onepassword).

[![Screenshot - Clean](https://github.com/bkuhlmann/auther/raw/master/screenshot-clean.png)](https://github.com/bkuhlmann/auther)
[![Screenshot - Error](https://github.com/bkuhlmann/auther/raw/master/screenshot-error.png)](https://github.com/bkuhlmann/auther)

* Encrypted account credentials.
* Multiple account support with account specific blacklisted paths.
* Auto-redirection to requested path (once credentials have been verified).
* Log filtering for account credentials (login and password).
* Customizable logger support.
* Customizable view support.
* Customizable controller support.

# Requirements

0. Any of the following Ruby VMs:
    * [MRI 2.x.x](http://www.ruby-lang.org)
    * [JRuby 1.x.x](http://jruby.org)
    * [Rubinius 2.x.x](http://rubini.us)
0. [Ruby on Rails 4.x.x](http://rubyonrails.org).

# Setup

For a secure install, type the following from the command line (recommended):

    gem cert --add <(curl -Ls http://www.redalchemist.com/gem-public.pem)
    gem install auther --trust-policy MediumSecurity

NOTE: A HighSecurity trust policy would be best but MediumSecurity enables signed gem verification while
allowing the installation of unsigned dependencies since they are beyond the scope of this gem.

For an insecure install, type the following (not recommended):

    gem install auther

Add the following to your Gemfile:

    gem "auther"

Edit your routes.rb as follows:

    Rails.application.routes.draw do
      mount Auther::Engine => "/auther"
      get "/login", to: "auther/session#new", as: "login"
      destroy "/logout", to: "auther/session#destroy", as: "logout"
    end

Add a config/initializers/auther.rb to your application with the following content:

    Rails.application.config.auther_settings = {
      secret: "vuKrwD9XWoYuv@s99?tR(9VqryiL,KV{W7wFnejUa4QcVBP+D{2rD4JfuD(mXgA=$tNK4Pfn#NeGs3o3TZ3CqNc^Qb",
      accounts: [
        name: "admin",
        login: "N3JzR213WlBISDZsMjJQNkRXbEVmYVczbVdnMHRYVHRud29lOWRCekp6ST0tLWpFMkROekUvWDBkOHZ4ZngxZHV6clE9PQ==--cd863c39991fa4bb9a35de918aa16da54514e331",
        password: "cHhFSStjRm9KbEYwK3ZJVlF2MmpTTWVVZU5acEdlejZsZEhjWFJoQWxKND0tLTE3cmpXZVBQdW5VUW1jK0ZSSDdLUnc9PQ==--f51171174fa77055540420f205e0dd9d499cfeb6",
        paths: ["/admin"]
      ],
      auth_url: "/login"
    }

The purpose of each setting is as follows:

* *title* - Optional. The HTML page title (as rendered within a browser tab). Default: "Authorization".
* *label* - Optional. The page label (what would appear above the form). Default: "Authorization".
* *secret* - Required. The secret passphrase used to encrypt/decrypt account credentials.
* *accounts* - Required. The array of accounts with different or similar access to the application.
    * *name* - Required. The account name. The name that uniquely identifies each account.
    * *login* - Required. The encrypted account login. For example, the above decrypts to: *test@test.com*.
    * *password* - Required. The encrypted account password. For example, the above decrypts to: *password*.
    * *paths* - Required. The array of blacklisted paths for which only this account has access to.
    * *success_url* - Optional. The URL to redirect to upon successful authorization. Success redirection works
      as follows (in the order defined):

          0. The blacklisted path (if requested prior to authorization but now authorized).
          0. The success URL (if defined and the blacklisted path wasn't requested).
          0. The root path (if none of the above).
* *auth_url* - Required. The URL to redirect to when enforcing authentication to a blacklisted path.
* *logger* - Optional. The logger used to log path/account authorization messages. Default: Auther::NullLogger.

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
gem and need a different solution altogether if it comes to that.

## Views

The view can be customized by creating the following file within your Rails application (assumes that the
default Auther::SessionController implementation is sufficient):

    app/views/auther/session/new.html

The form can be stylized by attaching new styles to the .authorization class (see
[auther.scss](app/assets/stylesheets/auther/auther.scss) for details).

## Controller

The [Auther::SessionController](app/controllers/auther/session_controller.rb) inherits from the
[Auther::BaseController](app/controllers/auther/base_controller.rb). To customize, it is recommended that
you add a controller to your app that inherits from the Auther::BaseController. Example:

    # Example Path:  app/controllers/session_controller.rb
    class SessionController < Auther::BaseController
      layout "example"
    end

This allows complete customization of session controller behavior to serve any special business needs. See the
Auther::BaseController for additional details or the Auther::SessionController for default implementation.

## Routes

As mentioned in the setup above, the routes can be customized as follows:

    Rails.application.routes.draw do
      mount Auther::Engine => "/auther"
      get "/login", to: "auther/session#new"
      delete "/logout", to: "auther/session#destroy"
    end

## Logging

As mentioned in the setup above, the logger can be customized as follows:

    Auther::NullLogger.new # This is the default logger (which is no logging at all).
    ActiveSupport::Logger.new("log/#{Rails.env}.log") # Can be used to log to the environment log.
    Logger.new($stdout) # Can be used to log to standard output.

When logging is enabled, you'll be able to see the following information in the server logs to help debug custom
Auther settings:

* Requested path and blacklist path detection.
* Finding (or not finding) of account.
* Account authentication pass/fail.
* Account and path authorization pass/fail.

# Tests

To test, do the following:

0. cd to the gem root.
0. bundle install
0. bundle exec rspec spec

# Troubleshooting

* If upgrading Rails, changing the cookie/session settings, generating a new secret base key, etc. this might
  cause Auther authentication to fail. Make sure to clear your browser cookies in this situation or use Google
  Chrome (incognito mode) to verify.

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
