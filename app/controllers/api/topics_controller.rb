class Api::TopicsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  
  respond_to :json
  
  authorize_actions_for Topic
  
  def index
    @topics = Topic.find_active.sorted
    if derived_version < 2 
      respond_with(@topics)
    else
      respond_with(@topics, root: false)
    end
  end
end
