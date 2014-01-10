Auther::Engine.routes.draw do
  root to: "session#new"
  resource :session, controller: "session", only: [:show, :new, :create, :destroy]
end
