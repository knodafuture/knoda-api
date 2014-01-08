class Api::TopicsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  
  authorize_actions_for Topic
  
  def index
    @topics = Topic.find_active.sorted
    respond_with(@topics)
  end
end
