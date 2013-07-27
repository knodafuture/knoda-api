class Api::TopicsController < ApplicationController
  skip_before_filter :verify_authenticity_token 
  skip_before_filter :authenticate_user_please!
  
  respond_to :json
  
  def index
    if params[:pattern]
      respond_with(Topic.find_active_by_pattern(params[:pattern]))
    else
      respond_with(Topic.find_active)
    end
  end
end
