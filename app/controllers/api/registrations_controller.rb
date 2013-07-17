class Api::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user_please!, :only => [:create]
  
  def create
    build_resource(sign_up_params)
 
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        sign_in(resource_name, resource)
        resource.reset_authentication_token!
        resource.save!
        return render :json => {:success => true, :auth_token => resource.authentication_token}
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        return render :json => {:success => true}
      end
    else
      clean_up_passwords resource
      return render :json => {:success => false, :errors => resource.errors}
    end
  end
end
