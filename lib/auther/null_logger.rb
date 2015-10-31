module Auther
  # The default logger which purposefully does nothing at all.
  class NullLogger
    def initialize _
    end

    def info _
    end

    def warn _
    end

    def error _
    end

    def fatal _
    end

    def debug _
    end
  end
end
