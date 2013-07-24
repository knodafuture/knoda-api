Knoda::Application.routes.draw do
  root 'mobile#index'

  resources :challenges, only: [:index, :show]
  resources :predictions

  get 'tags/:tag', to: 'predictions#index', as: :tag

  get 'users/sign_in'       => 'mobile#index'
  get 'users/sign_up'       => 'mobile#index'
  get 'users/password/new'  => 'mobile#index'

  # for iOS API
  namespace :api do
    resources :registrations, :only => [:create]
    resources :topics,        :only => [:index]
    resources :challenges,    :only => [:index, :show]
    resources :predictions,   :only => [:index, :show, :create, :destroy] do
      member do
        post 'agree'
        post 'disagree'
        post 'realize'
        post 'unrealize'
        get  'history'
      end
    end
    resources :badges,        :only => [:index] do
      collection do
        get 'recent'
      end
    end
    resources :users,         :only => [:show] do
      member do
        get 'predictions'
      end
    end
    resource  :profile,       :only => [:show, :update]
    resource  :password,      :only => [:create, :update]
  end

  devise_for :users, skip: :registrations
  devise_scope :user do
    namespace :api do
      resource :session,      :only => [:create, :destroy]
      resource :registration, :only => [:create]
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
  # get 'terms' => 'pages#terms'
  # get 'about' => 'pages#about'

  # admin namespace
  # namespace :admin do
  #  resources :users
  #  resources :predictions
  # end
end
