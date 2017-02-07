# frozen_string_literal: true

Auther::Engine.routes.draw do
  root to: "session#new"
  resource :session, controller: "session", only: %i[show new create destroy]
end
