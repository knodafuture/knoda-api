class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_user_please!
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit :username, :email, :password
    end
  end
  
  def authenticate_user_please!
    unless current_user
      respond_to do |format|
        format.html {authenticate_user!}
        format.any  {render nothing: true, status: :forbidden}
      end
    end
  end
  
  def param_limit
    params[:limit] || 50
  end
  
  def param_offset
    params[:offset] || 0
  end

  def param_id_lt
    params[:id_lt]
  end
  
  def param_created_at_lt
    params[:created_at_lt]
  end
  
  def pagination_meta(collection)
    if collection
      {offset: param_offset, limit: param_limit, count: collection.count}
    end
  end
end
