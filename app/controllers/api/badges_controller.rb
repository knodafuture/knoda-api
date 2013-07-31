class Api::BadgesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  authorize_actions_for Badge
  respond_to :json
  
  def index
    respond_with(current_user.badges)
  end
  
  def recent
    @badges = current_user.badges.unseen.all
    current_user.badges.unseen.update_all(seen: true)
    respond_with(@badges)
  end
end