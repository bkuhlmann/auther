# frozen_string_literal: true

require "auther/authenticator"
require "auther/cipher"
require "auther/engine"
require "auther/gatekeeper"
require "auther/keymaster"
require "auther/settings"
require "logger"

module Auther
  LOGGER = Logger.new(nil).freeze
end
