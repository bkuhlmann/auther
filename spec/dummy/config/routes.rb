Rails.application.routes.draw do
  mount Auther::Engine => "/auther"
  resource :portal, controller: "portal", only: :show do
    resource :dashboard, controller: "dashboard", only: :show
  end
  get "/trailer", to: "portal#show"
end
