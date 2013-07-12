class Api::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token
  prepend_before_filter :require_no_authentication, :only => [:create]
  include Devise::Controllers::Helpers

  respond_to :json

  def create
    self.resource = warden.authenticate!({:scope => :user})
    sign_in(resource_name, resource)
    resource.reset_authentication_token!
    resource.save!
    render json: { auth_token: resource.authentication_token,
      login: resource.username,
      email: resource.email,
    }
  end

  def destroy
    sign_out(resource_name)
  end
end
