Rails.application.routes.draw do
  resources :characters
  resources :guilds

  get '/characters/challenge_mode/:id', to: 'characters#challenge_mode'
  get '/characters/pets_mounts/:id', to: 'characters#pets_mounts'
  get '/characters/achievements/:id', to: 'characters#achievements'

  root to: 'visitors#index'
end
