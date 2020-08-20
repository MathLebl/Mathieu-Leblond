Rails.application.routes.draw do
  resources :users, only: [:show ] do
  end

  ActiveAdmin.routes(self)
  devise_for :users
  root to: 'pages#home'
  get '/template', to: redirect('/template_free.rb')
  get '/template_folder', to: redirect('/rails-stylesheets-perso.zip')
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
