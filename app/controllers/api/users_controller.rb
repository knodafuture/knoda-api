class Api::UsersController < ApplicationController
  before_action :set_user, :only => [:show, :predictions]
  skip_before_filter :authenticate_user_please!, :only => [:show, :predictions]
  
  respond_to :json
  
  def show
    respond_with(@user)
  end
  
  def predictions    
    respond_with(@user.predictions.latest)
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
end
