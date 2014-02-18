class Api::AndroidDeviceTokensController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  respond_to :json
  
  authorize_actions_for AndroidDeviceToken, :only => ['index', 'create', 'show']
  
  def index    
    respond_with(current_user.android_device_tokens)
  end
  
  def show
    respond_with(current_user.android_device_tokens.find(params[:id]))
  end
  
  def create  
    @token = AndroidDeviceToken.find_or_initialize_by_token(required_params[:token])
    @token.user = current_user
    @token.save
    respond_with(@token, location: nil) 
  end

  def destroy
    @token = current_user.android_device_tokens.find(params[:id])
    authorize_action_for(@token)
    @token.delete
    respond_to do |format|
      format.any { head :no_content }
    end
  end
  
  private
  
  def required_params
    params.permit(:token)
  end
end
