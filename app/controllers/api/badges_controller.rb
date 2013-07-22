class Api::BadgesController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  respond_to :json
  
  def index
    respond_with(current_user.badges)
  end
end