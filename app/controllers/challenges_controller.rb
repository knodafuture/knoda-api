class ChallengesController < ApplicationController
  before_filter :require_login
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

  def require_login
    unless current_user
      flash[:error] = "You must be logged in to access this section"

      respond_to do |format|
        format.html { redirect_to new_user_session_url }
        format.json { render json: {success: false}, :status => 403 }
      end
    end
  end
end
