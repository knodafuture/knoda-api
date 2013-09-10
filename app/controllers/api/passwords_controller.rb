class Api::PasswordsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user_please!, :only => [:create]
    
  def create
    user = User.find_first_by_auth_conditions(forgot_password_params)
    if user
      User.send_reset_password_instructions(user)
      head :no_content
    else
      head :not_found
    end
  end
    
  def update    
    unless current_user.valid_password?(password_params[:current_password])
      invalid_current_password
    else
      current_user.password = password_params[:new_password]
      current_user.password_confirmation = password_params[:new_password]
      current_user.authentication_token = nil

      if current_user.save
        current_user.apple_device_tokens.delete_all
        respond_to do |format|
          format.any { head :no_content }
        end
      else
        respond_to do |format|
          format.any { render json: {errors: current_user.errors}, status: :unprocessable_entity }
        end
      end
    end
  end
  
  private

  def forgot_password_params
    params.permit(:login)
  end

  def password_params
    params.permit(:current_password, :new_password)
  end

  def invalid_current_password
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your current password"}, :status=>422
  end
end
