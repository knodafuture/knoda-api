class Api::PasswordsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :require_login
  before_action :set_user, :only => [:update]
  
  def update
    unless @user.valid_password?(password_params[:current_password])
      invalid_current_password
    else
      @user.password = password_params[:new_password]
      @user.password_confirmation = password_params[:new_password]
      if @user.save
        respond_to do |format|
          format.any { head :no_content }
        end
      else
        respond_to do |format|
          format.any { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  private
  
  def set_user
    @user = current_user
  end
  
  def require_login
    unless current_user
      render :nothing => true, :status => :forbidden
    end
  end
  
  def password_params
    params.permit(:current_password, :new_password)
  end

  def invalid_current_password
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your current password"}, :status=>401
  end
  
end
