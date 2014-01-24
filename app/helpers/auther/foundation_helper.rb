module Auther
  module FoundationHelper
    def render_foundation_error enabled, classes: []
      classes << "error" if enabled
      classes.compact * ' '
    end
  end
end
