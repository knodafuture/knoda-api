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
        get 'available'
      end
    end
    resources :users,         :only => [:show, :update, :create] do
      member do
        get 'predictions'
        get 'leaders'
        get 'followers'
      end
      collection do
        get 'autocomplete'
      end
    end

    resource  :profile,       :only => [:show, :update]
    resource  :password,      :only => [:create, :update]

    resources :apple_device_tokens, :only => [:index, :show, :create, :destroy]
    resources :android_device_tokens, :only => [:index, :show, :create, :destroy]

    resources :comments, :only => [:index, :create]
    resources :activityfeed, :only => [:index] do
      collection do
        post 'seen'
      end
    end
    resources :groups do
      member do
        get 'leaderboard'
        get 'predictions'
        get 'memberships'
        delete 'avatar', to: 'groups#destroyAvatar'
      end
    end
    resources :memberships, :only => [:create, :destroy]
    resources :invitations, :only => [:create, :show]
    resources :social_accounts, :only => [:create, :update, :show, :destroy]
    resources :twitter
    resources :facebook
    resources :notification_settings, :only => [:index, :update]
    resources :settings, :only => [:index, :update]
    resources :contests do
      member do
        get 'predictions'
        get 'leaderboard'
      end
    end
    resources :contact_matches
    resources :followings
  end

  get 'users/password/edit' => 'mobile#pwreset'
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
