class Api::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user_please!, :only => [:create]
  skip_before_filter :require_no_authentication, only: [:create]

  def create
    puts "qwerty2"
    puts request.headers
    request.headers.each do |h|
      puts h
    end
    build_resource(sign_up_params)
    if request.headers['HTTP_USER_AGENT'].include? "Android"
      @user.signup_source = "ANDROID"
    end
    if request .headers['HTTP_USER_AGENT'].include? "CFNetwork"
      @user.signup_source = "IOS"
    end
    if resource.save
      set_flash_message :notice, :signed_up if is_navigational_format?
      sign_up(resource_name, resource)
      sign_in(resource_name, resource)
      resource.reset_authentication_token!
      resource.save!
      return render :json => {:success => true, :auth_token => resource.authentication_token}
    else
      clean_up_passwords resource
      return render :json => {:success => false, :errors => resource.errors}, :status => 400
    end
  end

  def sign_up_params
    if derived_version < 2
      super
    else
      return params.permit(:username, :email, :password)
    end
  end
end
