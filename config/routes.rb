Rails.application.routes.draw do
  resources :characters

  root to: 'visitors#index'
end
