class Api::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user_please!, :only => [:create]
  skip_before_filter :require_no_authentication, only: [:create]

  def create
    if current_user
      return convert_to_named_user
    else
      build_resource(sign_up_params)
      if resource.save
        UserEvent.new(:user_id => resource.id, :name => 'SIGNUP', :platform => get_signup_source()).save
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
  end

  private

  def sign_up_params
    if derived_version < 2
      super
    else
      return params.permit(:username, :email, :password)
    end
  end

  def get_signup_source
    if request.headers['HTTP_USER_AGENT'] and request.headers['HTTP_USER_AGENT'].include? "Android"
      return "ANDROID"
    end
    if request.headers['HTTP_USER_AGENT'] and request .headers['HTTP_USER_AGENT'].include? "CFNetwork"
      return "IOS"
    end
  end

  def convert_to_named_user
    resource = current_user
    resource.guest_mode = false
    if resource.update(sign_up_params)
      UserEvent.new(:user_id => resource.id, :name => 'CONVERT', :platform => get_signup_source()).save
      return render :json => {:success => true, :auth_token => resource.authentication_token}
    else
      clean_up_passwords resource
      return render :json => {:success => false, :errors => resource.errors}, :status => 400
    end
  end
end
