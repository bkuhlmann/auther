# v6.0.0 (2016-11-14)

- Fixed ActionDispatch::IntegrationTest deprecation warnings.
- Fixed README URLs to use HTTPS schemes where possible.
- Fixed Rakefile to safely load Gemsmith tasks.
- Fixed `before_filter` deprecation warnings.
- Fixed `render :text` deprecation warnings.
- Fixed contributing guideline links.
- Fixed space in lambda parameter.
- Added "pg" gem development dependency.
- Added Code Climate engine support.
- Added GitHub issue and pull request templates.
- Added IRB development console Rake task support.
- Added Reek support.
- Added Rubocop Style/SignalException cop style.
- Added Rubocop Style/StringLiteralsInInterpolation cop.
- Added Rubocop exceptions for dummy app long line lengths.
- Added Ruby 2.3.0 frozen string literal support.
- Added Travis CI PostgreSQL setup.
- Added `Gemfile.lock` to `.gitignore`.
- Added bond, wirb, hirb, and awesome_print development dependencies.
- Added frozen string pragma.
- Added versioning section to README.
- Updated GitHub issue and pull request templates.
- Updated README secure gem install documentation.
- Updated README to mention "Ruby" instead of "MRI".
- Updated README with Tocer generated Table of Contents.
- Updated RSpec temp directory to use Bundler root path.
- Updated Rubocop PercentLiteralDelimiters and AndOr styles.
- Updated dummy application to a Rails 5 application.
- Updated gem dependencies (Rails 4.2.5/RSpec 3.4.0).
- Updated gem dependencies.
- Updated gemspec with conservative versions.
- Updated to Code Climate Test Reporter 1.0.0.
- Updated to Code of Conduct, Version 1.4.0.
- Updated to Gemsmith 7.7.0.
- Updated to Rails 5.0.0.
- Updated to Rubocop 0.44.
- Updated to Ruby 2.2.4.
- Updated to Ruby 2.3.0.
- Updated to Ruby 2.3.1.
- Removed CHANGELOG.md (use CHANGES.md instead).
- Removed RSpec default monkey patching behavior.
- Removed Rake console task.
- Removed Ruby 2.1.x and 2.2.x support.
- Removed gemspec description.
- Removed rb-fsevent development dependency from gemspec.
- Removed terminal notifier gems from gemspec.
- Refactored RSpec spec helper configuration.
- Refactored Rake tasks to standard location.
- Refactored gemspec to use default security keys.
- Refactored version label method name.

# v5.0.1 (2015-11-11)

- Fixed issue with Bourbon/Neat not loading for apps that don't require them.

# v5.0.0 (2015-11-11)

- Added Bourbon, Neat, and Bitters support.
- Added Gemsmith development support.
- Added Identity module description.
- Added Patreon badge to README.
- Added Rubocop support.
- Added [pry-state](https://github.com/SudhagarS/pry-state) support.
- Added ability to query errors to account presenter.
- Added large/mobile screenshots to README.
- Added parameter permission checking to base controller.
- Added project name to README.
- Added table of contents to README.
- Updated Authenticator to accept keyword logger argument.
- Updated Code Climate to run when CI ENV is set.
- Updated Code of Conduct 1.3.0.
- Updated RSpec support kit with new Gemsmith changes.
- Updated engine to ignore modifying the DOM when errors are detected.
- Updated to Code of Conduct 1.2.0.
- Updated to Ruby 2.2.3.
- Updated to SVG README badge icon.
- Removed Foundation support.
- Removed GitTip badge from README.
- Removed Modernizr support.
- Removed Rails 4.1.x support.
- Removed jQuery support.
- Removed unnecessary exclusions from .gitignore.
- Refactored base controller account model variable.
- Refactored base controller account presenter instance variable.
- Refactored settings class to initialize by keyword arguments.

# v4.1.0 (2015-07-05)

- Removed JRuby support (no longer officially supported).
- Removed duplicate `#info` method in NullLogger.
- Fixed secure gem installs (new cert has 10 year lifespan).
- Added code of conduct documentation.
- Updated to Ruby 2.2.2.

# v4.0.0 (2014-12-26)

- Removed Ruby 2.0.0 support.
- Removed Rubinius support.
- Removed specific version requirements for SASS Rails gem.
- Added Rails 4.2.x support.
- Added Ruby 2.2.0 support.
- Updated gemspec to use RUBY_GEM_SECURITY env var for gem certs.
- Updated to Zurb Foundation 5.5.x.

# v3.2.0 (2014-10-12)

* Updated to [Foundation 5.4.x](https://github.com/zurb/foundation/releases/tag/v5.4.6) now that SASS issues are
  resolved.

# v3.1.0 (2014-09-20)

- Added the Guard Terminal Notifier gem.
- Updated to Ruby 2.1.3.
- Updated gemspec to add security keys unless in a CI environment.
- Updated Code Climate to run only if environment variable is present.
- Updated and locked to Foundation Rails 5.3.3 (See [Issue 5811](https://github.com/zurb/foundation/issues/5811)).
- Refactored RSpec setup and support files.

# v3.0.0 (2014-07-17)

- Removed Rails 4.0.x support.
- Added secure defaults for initializer.

# v2.2.0 (2014-07-06)

- Updated gem-public.pem for gem install certificate chain.
- Fixed engine asset pipeline issues.

# v2.1.0 (2014-06-17)

- Fixed bug where a second account (not defining the same blacklisted path as another account) could access the
  other account's blacklisted path.
- Fixed bug with incorrect logging of an authorized account.

# v2.0.0 (2014-06-11)

- Removed account success_url (has been renamed to authorized_url).
- Updated account settings to use encrypted_login and encrypted_password instead of login and password keys.
- Added an install generator for settings and routes.
- Added a settings object with sensible defaults.
- Added account deauthorized URL support.
- Added an account presenter.
- Added an account authenticator.
- Added Code Climate test coverage support.

# v1.4.0 (2014-05-28)

- Fixed missing highlighting of errors for login and password form fields.
- Added the success URL account setting.
- Updated logging message output.
- Updated documentation to use auther.rb initializer.

# v1.3.0 (2014-05-26)

- Fixed bug where defining a blacklisted path with a trailing slash would not be blacklisted.
- Fixed tilt gem warning related to loading SASS in a non thread-safe way.
- Fixed log error messages due to Modernizr assets missing from load path.
- Fixed loading of Coveralls within spec helper.
- Removed 25% top spacing from .authorization class.
- Updated to Ruby 2.1.2.
- Updated to Rails 4.1.1.
- Updated gem installation trust policy from HighSecurity to MediumSecurity to reduce gem dependency conflicts.
- Added .coveralls.yml with Travis CI support.
- Added optional page title and label support.
- Added optional logging support for blacklisted path/account detection.
- Added RSpec randomized testing and metadata filtering.
- Added pass/fail logging for requested path, account, account authentication, and path authorization.

# v1.2.0 (2014-04-07)

- Fixed bug with engine assets not being loaded properly within engine initializer.
- Updated to MRI 2.1.1.
- Updated to Rubinius 2.x.x support.
- Updated RSpec helper to disable GC for all specs in order to improve performance.
- Added Gemnasium support.
- Added Coveralls support.

# v1.1.0 (2014-02-16)

- Updated gemspec homepage URL to use GitHub project URL.
- Added JRuby and Rubinius VM support.

# v1.0.0 (2014-01-23)

- Added vertical alignment and title spacing to authorization view template.
- Added error messages to form fields when invalid.
- Updated gemspec summary and description text.

# v0.3.0 (2014-01-19)

- Refactored the session controller so that it can be easily customized.
- Added Zurb Foundation support.
- Added page title and label customization.
- Refactored the Gatekeeper to make better use of session, request, and response objects.
- Updated the account object to be able to validate session credentials.
- Added login and password log filter parameters.

# v0.2.0 (2014-01-12)

- Added session encryption/decryption support.
- Added an account model for easier validation of account information.

# v0.1.0 (2014-01-09)

- Initial version.