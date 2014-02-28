class Api::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user_please!, only: [:create, :authentication_failure]
  skip_before_filter :require_no_authentication, only: [:create]
  include Devise::Controllers::Helpers

  respond_to :json

  def create
    if derived_version < 2
      self.resource = warden.authenticate!({:scope => :user, :recall => 'api/sessions#authentication_failure'})
    else
      self.resource = User.where("lower(username) = ? OR lower(email) = ?", params[:login].downcase, params[:login].downcase).first()
      if not self.resource.valid_password?(params[:password]) 
        authentication_failure()
        return 
      end
    end
    sign_in(resource_name, resource)
    if resource.authentication_token.nil?
      resource.reset_authentication_token!
      resource.save!
    end
    
    render json: { success: true,
      auth_token: resource.authentication_token,
      user_id: resource.id,
      login: resource.username,
      email: resource.email,
    }
  end

  def destroy
    resource = User.find_by_authentication_token(params[:auth_token])
    resource.authentication_token = nil
    resource.save
    sign_out(resource_name)
    render :json => {success: true}, :status => :ok
  end
  
  def authentication_failure
    render json: {success: false}, status: :forbidden
  end
end