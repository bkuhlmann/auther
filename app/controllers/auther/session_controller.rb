class Auther::SessionController < Auther::BaseController
  layout "auther/auth"
  before_filter :name_options, only: [:new, :create]

  private

  def new_template_path
    "auther/session/new"
  end
end
