# frozen_string_literal: true

module Auther
  # The default logger which purposefully does nothing at all.
  class NullLogger
    def initialize _parameters
    end

    def info _message
    end

    def warn _message
    end

    def error _message
    end

    def fatal _message
    end

    def debug _message
    end
  end
end
