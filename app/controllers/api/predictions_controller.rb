class Api::PredictionsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user_please!
  before_action :set_prediction, :except => [:index, :create]
  
  respond_to :json
  
  authorize_actions_for Prediction, :only => [:index, :create, :show]
  
  def index
    if params[:tag]
      @predictions = Prediction.tagged_with(params[:tag])
    elsif params[:recent]
      @predictions = Prediction.recent
    elsif params[:user_recent]
      @predictions = Prediction.recent_by_user_id(current_user.id)
    elsif params[:user_expiring]
      @predictions = Prediction.expiring_by_user_id(current_user.id)
    else
      @predictions = current_user.predictions
    end
    
    respond_with(@predictions, each_serializer: PredictionFeedSerializer)
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
    respond_with(@prediction.challenges.where(is_own: false, agree: true))
  end
  
  def history_disagreed
    respond_with(@prediction.challenges.where(is_own: false, agree: false))
  end
  
  def agree
    authorize_action_for(@prediction)
    
    @challenge = current_user.pick(@prediction, true)
    @challenge.save
    respond_with(@challenge)
  end
  
  def disagree
    authorize_action_for(@prediction)
    
    @challenge = current_user.pick(@prediction, false)
    @challenge.save
    respond_with(@challenge)
  end
  
  def realize
    authorize_action_for(@prediction)
    
    if @prediction.close_as(true)
      respond_with(@prediction)
    else
      respond_with(@prediction.errors, status: 422)
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
    @challenge = current_user.challenges.where(prediction: @prediction).first
    @challenge.bs = true
    @challenge.save!
    
    @prediction.request_for_bs
    
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