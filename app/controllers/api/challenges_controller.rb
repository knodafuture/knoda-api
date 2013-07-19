class Api::ChallengesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  authorize_actions_for Challenge
  respond_to :json

  def index
    if params[:notifications]
      @challenges = Challenge.get_notifications_by_user_id(current_user.id)
    else
      @challenges = current_user.challenges
    end
    respond_with(@challenges)
  end

  def show
    respond_with(Challenge.find_by_prediction_id(params[:id]))
  end
end
