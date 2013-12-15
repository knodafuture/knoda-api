class Api::ChallengesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_challenge, :only => [:show]

  authorize_actions_for Challenge
  respond_to :json
  
  def index
    case (params[:list])
      when 'ownedAndPicked'
        @challenges = current_user.challenges.ownedAndPicked
      when 'own'
        @challenges = current_user.challenges.own
      when 'own_unviewed'
        @challenges = current_user.challenges.own.unviewed
      when 'picks'
        @challenges = current_user.challenges.picks
      when 'picks_unviewed'
        @challenges = current_user.challenges.picks.unviewed
      when 'won_picks'
        @challenges = current_user.challenges.won_picks
      when 'won_picks_unviewed'
        @challenges = current_user.challenges.won_picks.unviewed
      when 'lost_picks'
        @challenges = current_user.challenges.lost_picks
      when 'lost_picks_unviewed'
        @challenges = current_user.challenges.lost_picks.unviewed
      when 'completed'
        @challenges = current_user.challenges.completed
      when 'completed_unviewed'
        @challenges = current_user.challenges.completed.unviewed
      when 'expired'
        @challenges = current_user.challenges.expired
      when 'expired_unviewed'
        @challenges = current_user.challenges.expired.unviewed
      when 'notifications'
        @challenges = current_user.challenges.notifications
      when 'notifications_unviewed'
        @challenges = current_user.challenges.notifications.unviewed
      else
        @challenges = current_user.challenges
    end

    @challenges = @challenges.id_lt(param_id_lt)
    #@challenges = @challenges.created_at_lt(param_created_at_lt)
       
    respond_with(@challenges.offset(param_offset).limit(param_limit), 
      meta: pagination_meta(@challenges))
  end
  
  def set_seen
    current_user.challenges.where(id: params[:ids]).update_all(seen: true)
    head :no_content
  end
  
  def show
    respond_with(@challenge)
  end
  
  private
  
  def set_challenge
    @challenge = Challenge.find(params[:id])
  end
end
