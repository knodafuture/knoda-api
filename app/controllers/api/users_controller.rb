class Api::UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :require_login
  before_action :set_user, :only => [:show, :update]
  
  respond_to :json

  def show
    respond_with(@user) do |format|
      format.json { render json: @user }
    end
  end
  
  def update
    respond_with(@user) do |format|
      if @user.update(user_params)
        format.json { head :no_content }
      else
        format.json { render json: @user.errors, status: 422 }
      end
    end
  end

  private

  def set_user
    @user = current_user
  end
  
  def user_params
    params.require(:user).permit(:avatar)
  end
  
  def require_login
    unless current_user
      render :nothing => true, :status => :forbidden
    end
  end
end
