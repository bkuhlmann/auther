# Overview

Provides simple, form-based authentication for apps that need security but don't want to use the clunky UI of
HTTP Basic Authentication and/or want to be compatible with password managers.

[![Gem Version](https://badge.fury.io/rb/auther.png)](http://badge.fury.io/rb/auther)
[![Code Climate GPA](https://codeclimate.com/github/bkuhlmann/auther.png)](https://codeclimate.com/github/bkuhlmann/auther)
[![Travis CI Status](https://secure.travis-ci.org/bkuhlmann/auther.png)](http://travis-ci.org/bkuhlmann/auther)

# Features

* Form-based authentication compatible with password managers like [1Password](https://agilebits.com/onepassword).
* Multiple account support with account specific blacklisted paths.
* Auto-redirection to blacklisted path (once credentials have been verified).
* Customizable session view.
* Customizable session controller.

# Requirements

0. [Ruby 2.x.x](http://www.ruby-lang.org).
0. [Ruby on Rails 4.x.x](http://rubyonrails.org).

# Setup

Type the following from the command line to securely install (recommended):

    gem cert --add <(curl -Ls http://www.redalchemist.com/gem-public.pem)
    gem install auther -P HighSecurity

...or type the following to insecurely install (not recommended):

    gem install auther

Add the following to your Gemfile:

    gem "auther"

# Usage

Edit your routes.rb as follows:

    Rails.application.routes.draw do
      mount Auther::Engine => "/auther"
    end

Edit your application.rb as follows:

    module Example
      class Application < Rails::Application
        config.auther_settings = {
          accounts: [
            {
              name: "test",
              login: "test@test.com",
              password: "password",
              paths: ["/admin"]
            }
          ],
          auth_url: "/auther/session/new"
        }
      end
    end

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
