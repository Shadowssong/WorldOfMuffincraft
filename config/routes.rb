Rails.application.routes.draw do
  resources :characters do
    collection do
      get 'view', to: 'characters#view', as: :view
    end
  end
  resources :guilds

  get '/characters/challenge_mode/:id', to: 'characters#challenge_mode'
  get '/characters/pets_mounts/:id', to: 'characters#pets_mounts'
  get '/characters/achievements/:id', to: 'characters#achievements'
  get '/characters/progression/:id', to: 'characters#progression'
  get '/characters/reputation/:id', to: 'characters#reputation'

  root to: 'visitors#index'
end
