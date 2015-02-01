Rails.application.routes.draw do
  resources :characters
  resources :guilds

  get '/characters/challenge_mode/:id', to: 'characters#challenge_mode'
  get '/characters/pets_mounts/:id', to: 'characters#pets_mounts'

  root to: 'visitors#index'
end
