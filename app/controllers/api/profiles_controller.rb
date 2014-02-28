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
    if p[:email]
      p[:email] = CGI::unescape(p[:email])
    end
    respond_to do |format|
      if current_user.update(p)
        format.json { render json: current_user, status: 200 }
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
