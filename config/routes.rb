Knoda::Application.routes.draw do
  root 'pages#index'

  resources :challenges, only: [:index, :show]
  resources :predictions

  get 'tags/:tag', to: 'predictions#index', as: :tag

  # for iOS API
  namespace :api do
    resources :registrations, :only => [:create]
    resources :predictions, :only => [:index, :show, :create, :update, :destroy]
    resource :user, :only => [:show, :update]
    resource :password, :only => [:update]
  end

  devise_for :users, skip: :registrations
  devise_scope :user do
    namespace :api do
      resources :sessions, :only => [:create, :destroy]
    end

    resource :registration,
      only: [:new, :create, :edit, :update],
      path: 'users',
      path_names: { new: 'sign_up' },
      controller: 'devise/registrations',
      as: :user_registration do
        get :cancel
      end
  end

  # pages
  get 'terms' => 'pages#terms'
  get 'about' => 'pages#about'

  # admin namespace
  namespace :admin do
    resources :users
    resources :predictions
  end
end
