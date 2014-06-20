class Api::SocialAccountsController < ApplicationController
  respond_to :json
  skip_before_filter :verify_authenticity_token
  before_action :set_social_account, :except => [:create]

  def create
    provider = params[:provider_name]

    if provider == "twitter"
      @social_account = create_twitter_account()
    elsif provider == "facebook"
      @social_account = create_facebook_account()
    end

    unless @social_account
      return
    end
    respond_with(@social_account)
  end

  def update
    authorize_action_for(@social_account)
    p = social_account_update_params
    @social_account.update!(p)
    render json: @social_account
  end

  def show
    authorize_action_for(@social_account)
    respond_with(@social_account)
  end

  def destroy
    authorize_action_for(@social_account)
    @social_account.destroy
    respond_to do |format|
      format.any { head :no_content }
    end
  end

  def account_creation_error(provider, providerError, providerErrorCode)
    render json: { :success => false, :provider_error => providerError, :provider_error_code => providerErrorCode}, :status => 400
  end
  def create_twitter_account
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.config.twitter_key
      config.consumer_secret     = Rails.application.config.twitter_secret
      config.access_token        = params[:access_token]
      config.access_token_secret = params[:access_token_secret]
    end
    begin
      twitterUser = client.verify_credentials(:skip_status => 1)
    rescue Exception => e
      account_creation_error("Twitter", e.cause, e.code)
      return
    end
    username = twitterUser.screen_name.dup
    return current_user.social_accounts.create!(
      {
        provider_name: params[:provider_name],
        provider_id: params[:provider_id],
        access_token: params[:access_token],
        access_token_secret: params[:access_token_secret],
        provider_account_name: username
      })
  end

  def create_facebook_account
    begin
      graph = Koala::Facebook::API.new(params[:access_token])
      facebookUser = graph.get_object("me")
    rescue Exception => e
      account_creation_error("Facebook", e.fb_error_message, e.fb_error_code)
      return
    end
    return current_user.social_accounts.create!(
    {
      provider_name: params[:provider_name],
      provider_id: params[:provider_id],
      access_token: params[:access_token],
      provider_account_name: facebookUser["email"]
      })
  end

  private
    def set_social_account
      @social_account = SocialAccount.find(params[:id])
    end
    def social_account_create_params
      return params.permit(:provider_id, :provider_name, :access_token, :access_token_secret, :provider_account_name)
    end

    def social_account_update_params
      return params.permit(:access_token, :access_token_secret)
    end
end
