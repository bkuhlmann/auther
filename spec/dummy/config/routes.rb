Rails.application.routes.draw do
  mount Auther::Engine => "/auther"
  get "/login", to: "auther/session#new", as: "login"
  delete "/logout", to: "auther/session#destroy", as: "logout"

  resource :portal, controller: "portal", only: :show do
    resource :dashboard, controller: "dashboard", only: :show
  end

  resource :deauthorized, controller: "deauthorized", only: :show

  get "/trailer", to: "portal#show"
end
