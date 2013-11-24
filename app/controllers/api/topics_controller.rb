class Api::TopicsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  respond_to :json
  
  authorize_actions_for Topic
  
  def index
    if params[:pattern]
      respond_with(Topic.find_active_by_pattern(params[:pattern]))
    else
      @topics = Rails.cache.fetch("out_of_stock_products", :expires_in => 2.hours) do
        Topic.find_active
      end
      respond_with(@topics)
    end
  end
end
