class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_filter :check_removed_api
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_user_please!
  after_filter :clear_session
 
  def clear_session
    session.clear
  end


  rescue_from ActionController::ParameterMissing do |exception|
    render json: {error: 'required parameter missing'}, status: 422
  end
 
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {error: 'item not found'}, status: 404
  end
  
  protected

  def check_removed_api
    mv = Rails.application.config.minimum_version
    if derived_version < Rails.application.config.minimum_version
      render json: {error: "Version not supported, mimimum version is #{mv}", status: :gone}
    end
  end  

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit :username, :email, :password
    end
  end
  
  def authenticate_user_please!
    unless current_user
      respond_to do |format|
        format.html {authenticate_user!}
        format.any  {render nothing: true, status: 401}
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

  def param_id_gt
    params[:id_gt]
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
