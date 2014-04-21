class MobileController < ApplicationController
	layout 'mobile/layout'
  skip_before_filter :authenticate_user_please!

  def index
    redirect_to "#{Rails.application.config.knoda_web_url}"
  end

  def pwreset
    redirect_to "#{Rails.application.config.knoda_web_url}/users/password/edit?reset_password_token=#{params[:reset_password_token]}"
  end
end
