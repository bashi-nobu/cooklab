Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'users/confirmations', registrations: 'users/registrations', omniauth_callbacks: "users/omniauth_callbacks" }
  devise_scope :user do
    get '/users/sign_up/:account_patarn' => 'users/registrations#new', as: :new_user_registration_customize
    get '/users/edit/:account_patarn' => 'users/registrations#edit', as: :edit_user_registration_customize
    get '/users/complete/:sign_in_count' => 'users/registrations#complete', as: :new_user_registration_complete
    get '/users/send/:sign_in_count' => 'users/registrations#mail_send', as: :new_user_registration_send
    get '/users/delete' => 'users/registrations#delete', as: :delete_user
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :top, only: :index
  resources :users, only: [:index]
  get 'users/my_page/:info_patarn' => "users#my_page", as: :user_my_page
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

  resources :payments, only: [:edit, :create, :destroy] do
    collection do
      post 'purchase_charge'
      post 'purchase_subscription'
      post 'card_change'
    end
  end
  get 'payments/new_card/:pay_patarn' => "payments#new_card", as: :new_card_registration
  get 'payments/delete' => "payments#delete", as: :delete_payment
  root 'top#index'
end
