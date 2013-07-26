class Api::UsersController < ApplicationController
  before_action :set_user, :only => [:show, :predictions]
  skip_before_filter :authenticate_user_please!, :only => [:show, :predictions]
  
  respond_to :json
  
  def show
    respond_with(@user)
  end
  
  def predictions
    rl = params[:limit]  || 30
    ro = params[:offset] || 0
    
    @predictions = @user.predictions.order("created_at DESC").offset(ro).limit(rl)
    respond_with(@predictions)
    #respond_with({
    #  total: @predictions.count,
    #  limit: rl,
    #  offset: ro,
    #  predictions: @predictions
    #})
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
end
