class Api::ProfilesController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  respond_to :json

  def show
    @user = current_user
    respond_with @user
  end
  
  def update
    respond_with(current_user) do |format|
      if current_user.update(user_params)
        format.json { head :no_content }
      else
        format.json { render json: {errors: current_user.errors}, status: 422 }
      end
    end
  end

  private
    
  def user_params
    params.require(:user).permit(:avatar, :notifications, :username, :email)
  end
end
