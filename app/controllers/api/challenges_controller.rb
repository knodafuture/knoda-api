class Api::ChallengesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_challenge, :only => [:show]

  authorize_actions_for Challenge
  respond_to :json
  
  def index
    case (params[:list] || 'all')
      when 'all'
        @challenges = current_user.challenges
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
    end
    
    @challenges = @challenges.offset(param_offset).limit(param_limit)
    @meta = {offset: param_offset, limit: param_limit, count: @challenges.count}
    
    respond_with(@challenges, meta: @meta)
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
