class Api::ChallengesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  authorize_actions_for Challenge
  respond_to :json
  
  def index
    respond_with(current_user.challenges)
  end
  
  def show
    respond_with(Challenge.find_by_prediction_id(params[:id]))
  end
end
