Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'users/confirmations' }
  # アカウント作成ページへのパスをカスタマイズ(アカウント作成時に無料会員か有料会員か判別するためのパラメータをnewアクションに追加)
  devise_for :users, controllers: { registrations: 'users/registrations' }, only: [:create, :edit, :update, :destroy]
  devise_scope :user do
    get '/users/sign_up/:account_patarn' => 'users/registrations#new', as: :new_user_regist
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

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
