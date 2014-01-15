class Api::ChallengesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_challenge, :only => [:show]

  authorize_actions_for Challenge
  respond_to :json
  
  def index
    case (params[:list])
      when 'ownedAndPicked'
        @challenges = current_user.challenges.ownedAndPicked
      else
        @challenges = current_user.challenges
    end

    @challenges = @challenges.id_lt(param_id_lt)
    #@challenges = @challenges.created_at_lt(param_created_at_lt)
       
    respond_with(@challenges.offset(param_offset).limit(param_limit), 
      each_serializer: HistorySerializer,
      meta: pagination_meta(@challenges))
  end
  
  def set_seen
    current_user.challenges.where(id: params[:ids]).update_all(seen: true)
    head :no_content
  end
  
  def show
    respond_with(@challenge)
  end

  def create
    c = challenge_params
    prediction = Prediction.find(c['prediction_id'])
    if (current_user.id != prediction.user_id) && !prediction.is_expired? && !prediction.is_closed?   
     @challenge = current_user.challenges.where(prediction: prediction).first
      if @challenge
        @challenge.update(c)
      else
        @challenge = current_user.challenges.create(c)
      end
      show()   
    else
      render :json => {success: false}, :status => :ok
    end
  end  
  
  private
  
  def set_challenge
    @challenge = Challenge.find(params[:id])
  end
end
