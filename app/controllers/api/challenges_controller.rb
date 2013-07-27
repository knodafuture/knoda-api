class Api::ChallengesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_challenge, :only => [:show]

  #authorize_actions_for Challenge
  respond_to :json

  def own
    @challenges = current_user.challenges.own
    respond_with(@challenges)
  end
  
  def picks
    @challenges = current_user.challenges.picks
    respond_with(@challenges)
  end
  
  def completed
    @challenges = current_user.challenges.completed
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
  
  def expired
    @challenges = Challenge.joins(:prediction)
      .where(user: current_user)
      .where("is_closed is false and expires_at <= ?", Time.now)
      .order("expires_at DESC")
    respond_with(@challenges)
  end
  
  private
  
  def set_challenge
    @challenge = Challenge.find(params[:id])
  end
end
