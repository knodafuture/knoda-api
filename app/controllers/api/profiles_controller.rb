class Api::ProfilesController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  respond_to :json

  def show
    respond_with current_user
  end
  
  def update
    if derived_version >= 2
      p = user_params_v2
    else
      p = user_params
    end
    respond_with(current_user) do |format|
      if current_user.update(p)
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

    def user_params_v2
      params.permit(:avatar, :notifications, :username, :email)
    end

end
