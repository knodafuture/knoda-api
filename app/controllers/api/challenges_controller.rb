class Api::ChallengesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  authorize_actions_for Challenge
  respond_to :json
  
  def index
    respond_with([:api, current_user.challenges])
  end
end
