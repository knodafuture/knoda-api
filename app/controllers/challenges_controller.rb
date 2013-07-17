class ChallengesController < ApplicationController
  before_action :set_challenge, only: [:show]
  respond_to :html, :json
  
  authorize_actions_for Challenge

  def index
    @challenges = current_user.challenges
    respond_with(@challenges)
  end

  def show
    respond_with(@challenge)
  end

  private

  def set_challenge
    @challenge = Challenge.find_by_prediction_id(params[:id])
  end

  def prediction_params
    params.require(:prediction).permit(:user_id, :prediction_id, :is_positive)
  end
end
