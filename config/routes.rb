Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'bookmarks/new'
  resources :lists do
    resources :bookmarks, only: %i[index show new create]
  end
  resources :bookmarks, only: %i[show destroy]
  # Defines the root path route ("/")
  # root "articles#index"
end
