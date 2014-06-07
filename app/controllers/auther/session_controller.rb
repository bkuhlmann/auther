class Auther::SessionController < Auther::BaseController
  layout "auther/auth"
  before_filter :load_title, :load_label
  before_filter :load_account_options, only: [:new, :create]

  private

  def new_template_path
    "auther/session/new"
  end
end
