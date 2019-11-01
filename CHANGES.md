# 10.2.3 (2019-11-01)

- Added Rubocop Rake support.
- Updated to RSpec 3.9.0.
- Updated to Rake 13.0.0.
- Updated to Rubocop 0.75.0.
- Updated to Rubocop 0.76.0.
- Updated to Ruby 2.6.5.

# 10.2.2 (2019-09-01)

- Updated to Rubocop 0.73.0.
- Updated to Rubocop Performance 1.4.0.
- Updated to Ruby 2.6.4.
- Refactored RSpec helper support requirements.
- Refactored structs to use hash-like syntax.

# 10.2.1 (2019-06-01)

- Fixed RSpec/ContextWording issues.
- Updated Reek configuration to disable IrresponsibleModule.
- Updated contributing documentation.
- Updated to Gemsmith 13.5.0.
- Updated to Git Cop 3.5.0.
- Updated to Reek 5.4.0.
- Updated to Rubocop 0.69.0.
- Updated to Rubocop Performance 1.3.0.
- Updated to Rubocop RSpec 1.33.0.

# 10.2.0 (2019-05-01)

- Fixed Rubocop layout issues.
- Added Rubocop Performance gem.
- Added Ruby warnings to RSpec helper.
- Added project icon to README.
- Updated RSpec helper to verify constant names.
- Updated to Code Quality 4.0.0.
- Updated to Rubocop 0.67.0.
- Updated to Ruby 2.6.3.
- Refactored account model to set safe path defaults.

# 10.1.0 (2019-04-01)

- Fixed Rubocop Style/MethodCallWithArgsParentheses issues.
- Updated to Rubocop 0.63.0.
- Updated to Ruby 2.6.1.
- Updated to Ruby 2.6.2.
- Removed RSpec standard output/error suppression.

# 10.0.0 (2019-01-01)

- Fixed Circle CI cache for Ruby version.
- Fixed Layout/EmptyLineAfterGuardClause cop issues.
- Fixed Markdown ordered list numbering.
- Fixed Rubocop RSpec/ContextWording issues.
- Fixed Rubocop RSpec/ExampleLength issues.
- Fixed Rubocop RSpec/FilePath issues.
- Fixed Rubocop RSpec/MessageSpies issues.
- Fixed Rubocop RSpec/MultipleExpectations issues.
- Fixed Rubocop RSpec/NamedSubject issues.
- Fixed Rubocop RSpec/NestedGroups issues.
- Fixed Rubocop RSpec/RepeatedExample issues.
- Added Circle CI Bundler cache.
- Added Rubocop RSpec gem.
- Updated Circle CI Code Climate test reporting.
- Updated to Contributor Covenant Code of Conduct 1.4.1.
- Updated to Gemsmith 13.0.0.
- Updated to Git Cop 3.0.0.
- Updated to RSpec 3.8.0.
- Updated to Rubocop 0.58.0.
- Updated to Rubocop 0.60.0.
- Updated to Rubocop 0.61.x.
- Updated to Rubocop 0.62.0.
- Updated to Ruby 2.5.2.
- Updated to Ruby 2.5.3.
- Updated to Ruby 2.6.0.

# 9.3.0 (2018-07-01)

- Updated Semantic Versioning links to be HTTPS.
- Updated credentials generate outputted key format.
- Updated to Reek 5.0.
- Updated to Rubocop 0.57.0.
- Refactored gatekeeper spec hash alignment.

# 9.2.0 (2018-06-17)

- Added Rails credentials generator.
- Added cipher credentials generator.
- Updated project changes to use semantic versions.
- Removed packing of secret from initializer.
- Refactored RSpec credentials shared context.
- Refactored account model as struct.
- Refactored application specs.

# 9.1.0 (2018-04-01)

- Fixed Rubocop Style/MissingElse issues.
- Fixed gemspec issues with missing gem signing key/certificate.
- Added gemspec metadata for source, changes, and issue tracker URLs.
- Updated README license information.
- Updated gem dependencies.
- Updated to Circle CI 2.0.0 configuration.
- Updated to Gemsmith 12.0.0.
- Updated to Git Cop 2.2.0.
- Updated to PG 1.0.0.
- Updated to Rubocop 0.53.0.
- Updated to Ruby 2.5.1.
- Removed Circle CI Bundler cache.
- Removed Gemnasium support.
- Removed Patreon badge from README.
- Refactored temp dir shared context as a pathname.

# 9.0.0 (2018-01-01)

- Updated Code Climate badges.
- Updated Code Climate configuration to Version 2.0.0.
- Updated to Apache 2.0 license.
- Updated to Rubocop 0.52.0.
- Updated to Ruby 2.4.3.
- Updated to Ruby 2.5.0.
- Removed Reek IrresponsibleModule check.
- Removed black/white lists (use include/exclude lists instead).
- Removed documentation for secure installs.
- Refactored code to use Ruby 2.5.0 `Array#append` syntax.
- Refactored code to use Ruby 2.5.0 `Array#prepend` syntax.

# 8.1.1 (2017-11-19)

- Updated to Git Cop 1.7.0.
- Updated to Rake 12.3.0.

# 8.1.0 (2017-10-29)

- Fixed README layout issues.
- Added Bundler Audit gem.
- Updated to Rubocop 0.50.0.
- Updated to Rubocop 0.51.0.
- Updated to Ruby 2.4.2.
- Removed Pry State gem.

# 8.0.0 (2017-08-19)

- Fixed Rubocop Style/MixinGrouping issues.
- Fixed generator template to convert secret to bytes.
- Fixed missing space after pragma.
- Added Circle CI support.
- Added Git Cop code quality task.
- Added Rails 5.1.0 support.
- Added dynamic formatting of RSpec output.
- Updated CONTRIBUTING documentation.
- Updated GitHub templates.
- Updated README headers.
- Updated Rubocop configuration.
- Updated authentication form to use CSS Flexbox layout.
- Updated gem dependencies.
- Updated to Awesome Print 1.8.0.
- Updated to Gemsmith 10.0.0.
- Updated to Git Cop 1.3.0.
- Updated to Ruby 2.4.1.
- Removed Neat and Bourbon gems.
- Removed Travis CI support.

# 7.1.0 (2017-02-26)

- Fixed Cross-Site Request Forgery (CSRF) issue.
- Fixed Rubocop Style/AutoResourceCleanup issues.
- Fixed Rubocop Style/CollectionMethods issues.
- Fixed Rubocop Style/OptionHash issues.
- Fixed Rubocop Style/SymbolArray issues.
- Fixed Travis CI configuration to not update gems.
- Added code quality Rake task.
- Updated Guardfile to always run RSpec with documentation format.
- Updated README semantic versioning order.
- Updated RSpec configuration to output documentation when running.
- Updated RSpec spec helper to enable color output.
- Updated Rubocop to import from global configuration.
- Updated contributing documentation.
- Removed Code Climate code comment checks.
- Removed `.bundle` directory from `.gitignore`.

# 7.0.0 (2017-01-22)

- Updated Rubocop Metrics/LineLength to 100 characters.
- Updated Rubocop Metrics/ParameterLists max to three.
- Updated Travis CI configuration to use latest RubyGems version.
- Updated gemspec to require Ruby 2.4.0 or higher.
- Updated to Rubocop 0.47.
- Updated to Ruby 2.4.0.
- Removed Rubocop Style/Documentation check.
- Refactored test credentials to credentials context for specs.

# 6.1.0 (2016-12-18)

- Fixed Rakefile support for RSpec, Reek, Rubocop, and SCSS Lint.
- Updated Travis CI configuration to use defaults.
- Updated to Rake 12.x.x.
- Updated to Rubocop 0.46.x.
- Updated to Ruby 2.3.2.
- Updated to Ruby 2.3.3.

# 6.0.0 (2016-11-14)

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

# 5.0.1 (2015-11-11)

- Fixed issue with Bourbon/Neat not loading for apps that don't require them.

# 5.0.0 (2015-11-11)

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

# 4.1.0 (2015-07-05)

- Removed JRuby support (no longer officially supported).
- Removed duplicate `#info` method in NullLogger.
- Fixed secure gem installs (new cert has 10 year lifespan).
- Added code of conduct documentation.
- Updated to Ruby 2.2.2.

# 4.0.0 (2014-12-26)

- Removed Ruby 2.0.0 support.
- Removed Rubinius support.
- Removed specific version requirements for SASS Rails gem.
- Added Rails 4.2.x support.
- Added Ruby 2.2.0 support.
- Updated gemspec to use RUBY_GEM_SECURITY env var for gem certs.
- Updated to Zurb Foundation 5.5.x.

# 3.2.0 (2014-10-12)

* Updated to [Foundation 5.4.x](https://github.com/zurb/foundation/releases/tag/v5.4.6) now that SASS issues are
  resolved.

# 3.1.0 (2014-09-20)

- Added the Guard Terminal Notifier gem.
- Updated to Ruby 2.1.3.
- Updated gemspec to add security keys unless in a CI environment.
- Updated Code Climate to run only if environment variable is present.
- Updated and locked to Foundation Rails 5.3.3 (See [Issue 5811](https://github.com/zurb/foundation/issues/5811)).
- Refactored RSpec setup and support files.

# 3.0.0 (2014-07-17)

- Removed Rails 4.0.x support.
- Added secure defaults for initializer.

# 2.2.0 (2014-07-06)

- Updated gem-public.pem for gem install certificate chain.
- Fixed engine asset pipeline issues.

# 2.1.0 (2014-06-17)

- Fixed bug where a second account (not defining the same blacklisted path as another account) could access the
  other account's blacklisted path.
- Fixed bug with incorrect logging of an authorized account.

# 2.0.0 (2014-06-11)

- Removed account success_url (has been renamed to authorized_url).
- Updated account settings to use encrypted_login and encrypted_password instead of login and password keys.
- Added an install generator for settings and routes.
- Added a settings object with sensible defaults.
- Added account deauthorized URL support.
- Added an account presenter.
- Added an account authenticator.
- Added Code Climate test coverage support.

# 1.4.0 (2014-05-28)

- Fixed missing highlighting of errors for login and password form fields.
- Added the success URL account setting.
- Updated logging message output.
- Updated documentation to use auther.rb initializer.

# 1.3.0 (2014-05-26)

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

# 1.2.0 (2014-04-07)

- Fixed bug with engine assets not being loaded properly within engine initializer.
- Updated to MRI 2.1.1.
- Updated to Rubinius 2.x.x support.
- Updated RSpec helper to disable GC for all specs in order to improve performance.
- Added Gemnasium support.
- Added Coveralls support.

# 1.1.0 (2014-02-16)

- Updated gemspec homepage URL to use GitHub project URL.
- Added JRuby and Rubinius VM support.

# 1.0.0 (2014-01-23)

- Added vertical alignment and title spacing to authorization view template.
- Added error messages to form fields when invalid.
- Updated gemspec summary and description text.

# 0.3.0 (2014-01-19)

- Refactored the session controller so that it can be easily customized.
- Added Zurb Foundation support.
- Added page title and label customization.
- Refactored the Gatekeeper to make better use of session, request, and response objects.
- Updated the account object to be able to validate session credentials.
- Added login and password log filter parameters.

# 0.2.0 (2014-01-12)

- Added session encryption/decryption support.
- Added an account model for easier validation of account information.

# 0.1.0 (2014-01-09)

- Initial version.
