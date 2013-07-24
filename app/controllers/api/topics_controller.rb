class Api::TopicsController < ApplicationController
  skip_before_filter :verify_authenticity_token 
  skip_before_filter :authenticate_user_please!
  
  respond_to :json
  
  def index
    if topic_params[:pattern]
      @tags = ActsAsTaggableOn::Tag.where('name like ?', '%'+topic_params[:pattern]+'%').limit(20)
    else
      @tags = ActsAsTaggableOn::Tag.limit(20)
    end
    
    respond_with(@tags)
  end
  
  private
  
  def topic_params
    params.permit(:pattern)
  end
end
