class Api::UsersController < ApplicationController
  before_action :set_user, :only => [:show, :predictions]
  skip_before_filter :authenticate_user_please!, :only => [:show, :predictions]
  
  respond_to :json
  
  def show
    respond_with(@user)
  end
  
  def predictions
    @predictions = @user.predictions.latest.id_lt(param_id_lt)
    @meta = pagination_meta(@predictions)
    respond_with(@predictions.offset(param_offset).limit(param_limit))
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
end
