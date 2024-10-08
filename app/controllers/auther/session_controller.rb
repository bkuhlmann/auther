# frozen_string_literal: true

module Auther
  # Default implementation for session management.
  class SessionController < BaseController
    layout "auther/auth"
    before_action :load_title, :load_label
    before_action :load_account_options, only: %i[new create]

    protected

    def new_template_path = "auther/session/new"
  end
end
