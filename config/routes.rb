Rails.application.routes.draw do
  resources :characters
  resources :guilds

  root to: 'visitors#index'
end
