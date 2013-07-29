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
    @token = AppleDeviceToken.find_or_create_by_token(required_params[:token])
    @token.user = current_user
    
    respond_to do |format|
      if @token.save
        format.json { render json: @token, status: 201 }
      else
        format.json { render json: @token.errors, status: 422 }
      end
    end    
  end
  
  private
  
  def required_params
    params.require(:apple_device_token).permit(:token)
  end
end
