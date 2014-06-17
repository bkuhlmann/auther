# v2.1.0

* Fixed bug where a second account (not defining the same blacklisted path as another account) could access the
  other account's blacklisted path.
* Fixed bug with incorrect logging of an authorized account.

# v2.0.0

* Removed account success_url (has been renamed to authorized_url).
* Updated account settings to use encrypted_login and encrypted_password instead of login and password keys.
* Added an install generator for settings and routes.
* Added a settings object with sensible defaults.
* Added account deauthorized URL support.
* Added an account presenter.
* Added an account authenticator.
* Added Code Climate test coverage support.

# v1.4.0

* Fixed missing highlighting of errors for login and password form fields.
* Added the success URL account setting.
* Updated logging message output.
* Updated documentation to use auther.rb initializer.

# v1.3.0

* Fixed bug where defining a blacklisted path with a trailing slash would not be blacklisted.
* Fixed tilt gem warning related to loading SASS in a non thread-safe way.
* Fixed log error messages due to Modernizr assets missing from load path.
* Fixed loading of Coveralls within spec helper.
* Removed 25% top spacing from .authorization class.
* Updated to Ruby 2.1.2.
* Updated to Rails 4.1.1.
* Updated gem installation trust policy from HighSecurity to MediumSecurity to reduce gem dependency conflicts.
* Added .coveralls.yml with Travis CI support.
* Added optional page title and label support.
* Added optional logging support for blacklisted path/account detection.
* Added RSpec randomized testing and metadata filtering.
* Added pass/fail logging for requested path, account, account authentication, and path authorization.

# v1.2.0

* Fixed bug with engine assets not being loaded properly within engine initializer.
* Updated to MRI 2.1.1.
* Updated to Rubinius 2.x.x support.
* Updated RSpec helper to disable GC for all specs in order to improve performance.
* Added Gemnasium support.
* Added Coveralls support.

# v1.1.0

* Updated gemspec homepage URL to use GitHub project URL.
* Added JRuby and Rubinius VM support.

# v1.0.0

* Added vertical alignment and title spacing to authorization view template.
* Added error messages to form fields when invalid.
* Updated gemspec summary and description text.

# v0.3.0

* Refactored the session controller so that it can be easily customized.
* Added Zurb Foundation support.
* Added page title and label customization.
* Refactored the Gatekeeper to make better use of session, request, and response objects.
* Updated the account object to be able to validate session credentials.
* Added login and password log filter parameters.

# v0.2.0

* Added session encryption/decryption support.
* Added an account model for easier validation of account information.

# v0.1.0

* Initial version.
