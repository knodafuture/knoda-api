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
    get 'search/users' => 'search#users'
    get 'search/predictions' => 'search#predictions'
    resources :metrics,       :only => [:index]
    resources :registrations, :only => [:create]
    resources :topics,        :only => [:index]
    resources :challenges,    :only => [:index, :show, :create] do
      collection do
        post 'set_seen'
      end
    end
    resources :predictions,   :only => [:index, :show, :create, :update, :destroy] do
      member do
        get 'shorten'
        post 'agree'
        post 'disagree'
        post 'realize'
        post 'unrealize'
        post 'comment'
        get  'history_agreed'
        get  'history_disagreed'
        post 'bs'
        get  'challenge'
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
    
    resources :apple_device_tokens, :only => [:index, :show, :create, :destroy]

    resources :comments, :only => [:index, :create]
    resources :activityfeed, :only => [:index] do
      collection do
        post 'seen'
      end
    end      

  end

  devise_for :users, skip: :registrations
  devise_scope :user do
    namespace :api do
      resource :session,      :only => [:create, :destroy] do
        member do
          get 'authentication_failure'
        end
      end
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
end
