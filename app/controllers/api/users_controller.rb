class Api::UsersController < ApplicationController
  before_action :set_user, :only => [:show, :predictions]
  skip_before_filter :authenticate_user_please!, :only => [:show, :predictions]
  
  respond_to :json
  
  def show
    respond_with(@user)
  end
  
  def predictions
    @predictions = @user.predictions.latest.id_lt(param_id_lt)
  
    if derived_version >= 2
      serializer = PredictionFeedSerializerV2
      respond_with(@predictions.offset(param_offset).limit(param_limit),
        root: false, 
        each_serializer: serializer)      
    else
      serializer = PredictionFeedSerializer
      respond_with(@predictions.offset(param_offset).limit(param_limit),
        root: false, 
        meta: pagination_meta(@predictions), 
        each_serializer: serializer)      
    end
  end

  def autocomplete
    @users = User.search(params[:query], fields: [{:username => :text_start}], limit: 10)
  end  
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
end
