class Api::ChallengesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_challenge, :only => [:show]

  #authorize_actions_for Challenge
  respond_to :json
  
  def index
    case (params[:list] || '*')
      when 'own'
        @challenges = current_user.challenges.own
      when 'picks'
        @challenges = current_user.challenges.picks
      when 'won_picks'
        @challenges = current_user.challenges.won_picks
      when 'lost_picks'
        @challenges = current_user.challenges.lost_picks
      when 'completed'
        @challenges = current_user.challenges.completed
      when 'expired'
        @challenges = Challenge.joins(:prediction)
          .where(user: current_user)
          .where("is_closed is false and expires_at <= ?", Time.now)
          .order("expires_at DESC")
      else
        @challenges = current_user.challenges      
    end
    
    respond_with(@challenges)
  end
  
  def set_seen
    params[:ids].split(',').each do |id|
      challenge = current_user.challenges.where(id: id).first
      challenge.seen = true
      challenge.save
    end
    
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
