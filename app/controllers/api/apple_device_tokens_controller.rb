class Api::AppleDeviceTokensController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  respond_to :json
  
  authorize_actions_for AppleDeviceToken
  
  def index    
    respond_with(current_user.apple_device_tokens)
  end
  
  def show
    respond_with(current_user.apple_device_tokens.find(params[:id]))
  end
  
  def create  
    @token = AppleDeviceToken.find_or_initialize_by_token(required_params[:token])
    @token.user = current_user
    @token.save
    respond_with(@token, location: nil) 
  end

  def destroy
    @token = current_user.apple_device_tokens.find_by_token(required_params[:token])
    @token.delete

    respond_to do |format|
      format.any { head :no_content }
    end
  end
  
  private
  
  def required_params
    params.require(:apple_device_token).permit(:token)
  end
end
