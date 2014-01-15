class Api::AppleDeviceTokensController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  respond_to :json
  
  authorize_actions_for AppleDeviceToken, :only => ['index', 'create', 'show']
  
  def index    
    @tokens = current_user.apple_device_tokens
    respond_with(@tokens)
  end
  
  def show
    @token = current_user.apple_device_tokens.find(params[:id])
    respond_with(@token)
  end
  
  def create  
    @token = AppleDeviceToken.find_or_initialize_by_token(required_params[:token])
    @token.user = current_user

    if required_params[:sandbox] == "true"
      @token.sandbox = true
    end

    @token.save
    respond_with(@token, location: nil) 
  end

  def destroy
    @token = current_user.apple_device_tokens.find(params[:id])

    authorize_action_for(@token)

    @token.delete

    respond_to do |format|
      format.any { head :no_content }
    end
  end
  
  private
  
  def required_params
    params.require(:apple_device_token).permit(:token, :sandbox)
  end
end
