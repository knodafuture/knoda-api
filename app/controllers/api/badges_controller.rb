class Api::BadgesController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  respond_to :json
  
  def index
    respond_with(current_user.badges)
  end
  
  def recent
    @badges = current_user.badges.where(shown: false)
    @badges.each do |badge|
      badge.shown = true
      badge.save!
    end
    
    respond_with(@badges)
  end
end