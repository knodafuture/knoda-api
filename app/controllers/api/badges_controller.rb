class Api::BadgesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user_please!, :only => [:available]
  authorize_actions_for Badge, :except => :available
  respond_to :json
  
  def index
    if derived_version < 2
      respond_with(current_user.badges)
    else
      respond_with(current_user.badges, root: false)
    end
  end
  
  def recent
    @badges = current_user.badges.unseen.all
    current_user.badges.unseen.update_all(seen: true)
    if derived_version < 2
      respond_with(@badges)
    else
      respond_with(@badges, root: false)
    end    
  end

  def available
    @badges = []
    @badges << {:name => "gold_founding"}
    @badges <<  {:name => "silver_founding"}
    @badges <<  {:name => "1_prediction"}
    @badges <<  {:name => "10_predictions"}
    @badges <<  {:name => "1_challenge"}
    @badges <<  {:name => "10_correct_predictions"}
    @badges <<  {:name => "10_incorrect_predictions"}
    respond_with(@badges, root: false)
  end
end