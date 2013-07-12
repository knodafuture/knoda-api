class Api::ProfileController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :require_login
  before_action :set_user, :only => [:show, :edit, :update, :changepassword]

  def show
    respond_to do |format|
      format.json do
        render json: {
          "id"          => @user.id,
          "username"    => @user.username,
          "email"       => @user.email,
          "points"      => @user.points,
          "created_at"  => @user.created_at,
          "avatar"      => @user.avatar.url,
          "avatar_medium" => @user.avatar.url(:medium),
          "avatar_thumb"  => @user.avatar.url(:thumb)
        }
      end
    end
  end
  
  def edit
    
  end
  
  def update
    respond_to do |format|
      if (@user.update(user_params))
        format.html do
          raise @user.avatar.url
        end

        format.json do
          render json: {
            ok: "hello"
          }
        end
      else
        raise "error in updating"
      end

    end
  end

  def changepassword
    unless @user.valid_password?(change_password_params[:current_password])
      invalid_current_password
    else
      @user.password = change_password_params[:new_password]
      @user.password_confirmation = change_password_params[:new_password]
      if @user.save
        respond_to do |format|
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
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

  def change_password_params
    params.permit(:current_password, :new_password)
  end

  def require_login
    unless current_user
      render :nothing => true, :status => :forbidden
    end
  end

  def invalid_current_password
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your current password"}, :status=>401
  end
end
