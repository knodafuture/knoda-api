class Api::PredictionsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_prediction, :except => [:index, :create]
  
  respond_to :json
  
  authorize_actions_for Prediction, :only => [:index, :create, :show]
  
  def index
    if params[:tag]
      @predictions = Prediction.recent.tagged_with(params[:tag])
    elsif params[:recent]
      @predictions = Prediction.recent
    else
      @predictions = current_user.predictions
    end
    
    @predictions = @predictions.offset(param_offset).limit(param_limit)
        
    respond_with(@predictions, each_serializer: PredictionFeedSerializer, meta: pagination_meta(@predictions))
  end
  
  def create
    @prediction = current_user.predictions.create(prediction_create_params)  
    respond_with(@prediction)
  end
  
  def update
    authorize_action_for(@prediction)
    
    @prediction.update(prediction_update_params)
    respond_with(@prediction, serializer: PredictionFeedSerializer)
  end
  
  def show
    respond_with(@prediction, serializer: PredictionFeedSerializer)
  end
  
  def history_agreed
    respond_with(@prediction.challenges.agreed_by_users.limit(50), 
      each_serializer: ChallengeHistorySerializer,
      root: 'challenges')
  end
  
  def history_disagreed
    respond_with(@prediction.challenges.disagreed_by_users.limit(50), 
      each_serializer: ChallengeHistorySerializer,
      root: 'challenges')
  end
  
  def agree
    authorize_action_for(@prediction)
    
    @challenge = current_user.challenges.create(prediction: @prediction, agree: true)
    respond_with(@challenge)
  end
  
  def disagree
    authorize_action_for(@prediction)
    
    @challenge = current_user.challenges.create(prediction: @prediction, agree: false)
    respond_with(@challenge)
  end
  
  def realize
    authorize_action_for(@prediction)
    
    if @prediction.close_as(true)
      respond_with(@prediction)
    else
      render json: @prediction.errors, status: 422
    end
  end

  def unrealize
    authorize_action_for(@prediction)
    
    if @prediction.close_as(false)
      respond_with(@prediction)
    else
      respond_with(@prediction.errors, status: 422)
    end
  end
  
  def bs
    authorize_action_for(@prediction)
    
    @challenge = current_user.challenges.where(prediction: @prediction, is_own: false).first
    @challenge.update(bs: true)
    @challenge.prediction.request_for_bs
    
    head :no_content
  end
  
  def challenge
    @challenge = current_user.challenges.where(prediction: @prediction).first
    respond_with(@challenge)
  end
  
  private
  
  def set_prediction
    @prediction = Prediction.find(params[:id])
  end
  
  def prediction_create_params
    params.require(:prediction).permit(:body, :expires_at, :tag_list => [])
  end
  
  def prediction_update_params
    params.require(:prediction).permit(:expires_at)
  end
end