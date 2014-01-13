# Overview

Provides simple, form-based authentication for apps that need security but don't want to use the clunky UI of
HTTP Basic Authentication and/or want to be compatible with password managers.

[![Gem Version](https://badge.fury.io/rb/auther.png)](http://badge.fury.io/rb/auther)
[![Code Climate GPA](https://codeclimate.com/github/bkuhlmann/auther.png)](https://codeclimate.com/github/bkuhlmann/auther)
[![Travis CI Status](https://secure.travis-ci.org/bkuhlmann/auther.png)](http://travis-ci.org/bkuhlmann/auther)

# Features

* Encrypted session account credentials.
* Form-based authentication compatible with password managers like [1Password](https://agilebits.com/onepassword).
* Multiple account support with account specific blacklisted paths.
* Auto-redirection to requested path (once credentials have been verified).
* Customizable session view.
* Customizable session controller.

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
          accounts: [
            {
              name: "test",
              login: "N3JzR213WlBISDZsMjJQNkRXbEVmYVczbVdnMHRYVHRud29lOWRCekp6ST0tLWpFMkROekUvWDBkOHZ4ZngxZHV6clE9PQ==--cd863c39991fa4bb9a35de918aa16da54514e331",
              password: "cHhFSStjRm9KbEYwK3ZJVlF2MmpTTWVVZU5acEdlejZsZEhjWFJoQWxKND0tLTE3cmpXZVBQdW5VUW1jK0ZSSDdLUnc9PQ==--f51171174fa77055540420f205e0dd9d499cfeb6",
              paths: ["/admin"]
            }
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

Don't like the default authorization form? No problem, simply create the following file within your Rails application
to override the form provided by this engine and customize as you see fit:

    app/views/auther/session/new.html

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
