class Api::RegistrationsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  
  def create
    user = User.new(user_params)
    if user.save
      #render :json=> user.as_json(:auth_token=>user.authentication_token, :email=>user.email), :status => 201
      render :json => user, :status => 201
    else
      warden.custom_failure!
      render :json=> user.errors, :status => 422
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
end
