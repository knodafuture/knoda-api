class Api::ChallengesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  authorize_actions_for Challenge
  respond_to :json

  def index
    roffset = params[:offset] || 0
    rlimit  = params[:limit]  || 20    
    
    if params[:notifications]
      @challenges = Challenge.get_notifications_by_user_id(current_user.id).offset(roffset).limit(rlimit)
    else
      @challenges = current_user.challenges.offset(roffset).limit(rlimit)
    end
    
    respond_with(@challenges)
    #respond_with({
    #  total: @challenges.count,
    #  limit: rlimit,
    #  offset: roffset,
    #  challenges: @challenges
    #})
  end

  def show
    respond_with(Challenge.find_by_prediction_id(params[:id]))
  end
end
