class Api::TopicsController < ApplicationController
  skip_before_filter :verify_authenticity_token 
  skip_before_filter :authenticate_user_please!
  
  respond_to :json
  
  def index
    if topic_params[:pattern]
      @topics = Topic.where('hidden is false and name like ?', '%'+topic_params[:pattern]+'%').order("name")
    else
      @topics = Topic.where('hidden is false').order("name")
    end
    
    respond_with(@topics)
  end
  
  private
  
  def topic_params
    params.permit(:pattern)
  end
end
