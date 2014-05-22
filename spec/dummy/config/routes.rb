Rails.application.routes.draw do
  mount Auther::Engine => "/auther"
  resource :portal, controller: "portal"
  get "/trailer", to: "portal#show"
end
