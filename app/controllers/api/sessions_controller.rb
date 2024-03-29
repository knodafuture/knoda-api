class Api::SessionsController < Devise::SessionsController
  before_filter :check_removed_api
  before_action :update_sanitized_params, if: :devise_controller?
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user_please!, only: [:create, :authentication_failure]
  skip_before_filter :require_no_authentication, only: [:create]
  include Devise::Controllers::Helpers


  respond_to :json

  def create
    if derived_version < 2
      self.resource = warden.authenticate!({:scope => :user, :recall => 'api/sessions#authentication_failure'})
    else
      if params[:provider_name]
        self.resource = social_sign_in()
        if not self.resource
          return
        end
        unless self.resource.errors.empty?
          if self.resource.errors.include?(:email)
            self.resource.errors.add(:user_facing, "This email address is already registered. If you own this account, please login and connect to Facebook or Twitter in your profile.")
          end
          respond_with self.resource
          return
        end
      else
        self.resource = User.where("lower(username) = ? OR lower(email) = ?", params[:login].downcase, params[:login].downcase).first()
        if not self.resource or not self.resource.valid_password?(params[:password])
          authentication_failure()
          return
        end
      end
    end
    sign_in(resource_name, resource)
    if resource.authentication_token.nil?
      resource.reset_authentication_token!
      resource.save!
    end
    render json: { success: true,
      auth_token: resource.authentication_token,
      user_id: resource.id,
      login: resource.username,
      email: resource.email,
    }
  end

  def destroy
    resource = User.find_by_authentication_token(params[:auth_token])
    resource.authentication_token = nil
    resource.save
    sign_out(resource_name)
    render :json => {success: true}, :status => :ok
  end

  def authentication_failure
    render json: {success: false}, status: :forbidden
  end

  def social_authentication_failure(provider, providerError, providerErrorCode)
    render json: { :success => false, :provider_error => providerError, :provider_error_code => providerErrorCode}, :status => 400
  end

  def social_sign_in
    provider = params[:provider_name]
    if provider == 'twitter'
      return twitter_sign_in()
    elsif provider == 'facebook'
      return facebook_sign_in()
    end
  end

  def twitter_sign_in
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.config.twitter_key
      config.consumer_secret     = Rails.application.config.twitter_secret
      config.access_token        = params[:access_token]
      config.access_token_secret = params[:access_token_secret]
    end
    begin
      twitterUser = client.verify_credentials(:skip_status => 1)
    rescue Exception => e
      social_authentication_failure("Twitter", e.cause, e.code)
      return
    end
    #if twitterUser.profile_image_url
    #  twitterUser.profile_image_url = twitterUser.profile_image_url.to_s.sub! "_normal", "_bigger"
    #end
    username = twitterUser.screen_name.dup
    social_params = {
      provider_name: params[:provider_name],
      provider_id: params[:provider_id],
      access_token: params[:access_token],
      access_token_secret: params[:access_token_secret],
      username: username,
      image: twitterUser.profile_image_url,
      provider_account_name: username,
      signup_source: get_signup_source()
    }
    if current_user
      social_params[:current_user] = current_user
    end
    return User.find_or_create_from_social(social_params)
  end

  def facebook_sign_in
    begin
      graph = Koala::Facebook::API.new(params[:access_token])
      facebookUser = graph.get_object("me")
    rescue Exception => e
      social_authentication_failure("Facebook", e.fb_error_message, e.fb_error_code)
      return
    end
    social_params = {
      provider_name: params[:provider_name],
      provider_id: params[:provider_id],
      access_token: params[:access_token],
      email: facebookUser["email"],
      username: facebookUser["first_name"] + facebookUser["last_name"],
      image: "http://graph.facebook.com/#{params[:provider_id]}/picture?width=344&height=344",
      provider_account_name: facebookUser["email"],
      signup_source: get_signup_source()
    }
    if current_user
      social_params[:current_user] = current_user
    end
    return User.find_or_create_from_social(social_params)
  end

  def update_sanitized_params
    devise_parameter_sanitizer.for(:create) {|u| u.permit(:name, :email, :password, :provider, :providerId, :access_token, :access_token_secret)}
  end

  def check_removed_api
    mv = Rails.application.config.minimum_version
    if derived_version < Rails.application.config.minimum_version
      render json: {error: "Version not supported, mimimum version is #{mv}"}, status: :gone
    end
  end

  def get_signup_source
    if request.headers['HTTP_USER_AGENT'] and request.headers['HTTP_USER_AGENT'].include? "Android"
      return "ANDROID"
    end
    if request.headers['HTTP_USER_AGENT'] and request .headers['HTTP_USER_AGENT'].include? "CFNetwork"
      return "IOS"
    end
  end

end
