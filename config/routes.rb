Rails.application.routes.draw do
  get 'episodes/new'
  get 'episodes/create'
  get 'episodes/index'
  resources :episodes, only: [:index] do
    collection do
      get 'scrape_samec', to: 'episodes#scrape_samec'
    end
  end
  resources :users, only: [] do
    collection do
      get 'profile/:id', to: 'users#show'
    end
  end

  root to: 'pages#home'

  get '/template', to: redirect('/template_free.rb')
  get '/template_folder', to: redirect('/rails-stylesheets-perso.zip')
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  ActiveAdmin.routes(self)
  devise_for :users

end
