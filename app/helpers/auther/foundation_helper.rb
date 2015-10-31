module Auther
  # Foundation (CSS/JavaScript) framework helpers.
  module FoundationHelper
    def render_foundation_error enabled, options = {}
      classes = options.fetch :classes, []
      classes << "error" if enabled
      classes.compact * " "
    end
  end
end
