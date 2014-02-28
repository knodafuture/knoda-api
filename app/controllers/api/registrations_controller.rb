class Api::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user_please!, :only => [:create]
  skip_before_filter :require_no_authentication, only: [:create]
  
  def create
    build_resource(sign_up_params)
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
