class Api::TopicsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  respond_to :json
  
  authorize_actions_for Topic
  
  def index
    #@topics = Rails.cache.fetch("topics", :expires_in => 2.hours) do
    #  Topic.find_active
    #end
    @topics = Topic.find_active
    respond_with(@topics)
  end
end
