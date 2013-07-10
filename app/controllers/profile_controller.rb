class ProfileController < ApplicationController
  before_filter :require_login
  before_action :set_user, :only => [:show]
  
  def show
    respond_to do |format|
      format.json do
        render json: {
          "id"          => @user.id,
          "username"    => @user.username,
          "email"       => @user.email,
          "points"      => @user.points,
          "created_at"  => @user.created_at
        }
      end
    end
  end
  
  private
    def set_user
      @user = current_user
    end
    
    def change_password_params
      params.permit(:current_password, :new_password)
    end
    
    def require_login
      unless current_user
        render :nothing => true, :status => :forbidden
      end
    end
end
