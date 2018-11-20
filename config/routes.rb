Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :top, only: :index
  resources :users, only: [:show, :index]
  resources :video, only: :show do
    collection do
      get 'genre_search'
      get 'chef_search'
      get 'keyword_search'
    end
  end
  get 'video/chef_search_video/:chef_id' => "video#chef_search_video"
  resources :article, only: [:index, :show] do
    collection do
      get 'genre_search'
      get 'keyword_search'
    end
  end
  root 'top#index'
end
