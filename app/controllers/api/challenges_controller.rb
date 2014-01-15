class Api::ChallengesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_challenge, :only => [:show]

  authorize_actions_for Challenge
  respond_to :json
  
  def index
    case (params[:list])
      when 'ownedAndPicked'
        @challenges = Challenge.where(:user => current_user).ownedAndPicked
      else
        @challenges = current_user.challenges
    end
    @challenges = @challenges.id_lt(param_id_lt)
    @meta = pagination_meta(@challenges)
    respond_with(@challenges.offset(param_offset).limit(param_limit))
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
