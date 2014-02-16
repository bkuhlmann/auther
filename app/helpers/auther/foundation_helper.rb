module Auther
  module FoundationHelper
    def render_foundation_error enabled, options = {}
      classes = options.fetch :classes, []
      classes << "error" if enabled
      classes.compact * ' '
    end
  end
end
