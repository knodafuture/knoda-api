class Api::PredictionsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_prediction, :except => [:index, :create]
  
  respond_to :json
  
  authorize_actions_for Prediction, :only => [:index, :create, :show]
  
  def index
    if params[:tag]
      @predictions = Prediction.includes(:challenges, :comments).recent.latest.tagged_with(params[:tag])
    elsif params[:recent]
      @predictions = Prediction.includes(:challenges, :comments).recent.latest
    else
      @predictions = current_user.predictions
    end
    
    @predictions = @predictions.id_lt(param_id_lt)
        
    respond_with(@predictions.offset(param_offset).limit(param_limit), 
      each_serializer: PredictionFeedSerializer,
      meta: pagination_meta(@predictions))
  end

  def create
    @prediction = current_user.predictions.create(prediction_create_params)      
    respond_with(@prediction)
  end
  
  def update
    authorize_action_for(@prediction)
    p = prediction_update_params
    p[:activity_sent_at] = nil
    @prediction.update(p)
    Activity.where(user_id: @prediction.user.id, prediction_id: @prediction.id, activity_type: 'EXPIRED').delete_all
    respond_with(@prediction, serializer: PredictionFeedSerializer)
  end
  
  def show
    respond_with(@prediction, serializer: PredictionFeedSerializer)
  end
  
  def history_agreed
    respond_with(@prediction.challenges.agreed_by_users, 
      each_serializer: ChallengeHistorySerializer,
      root: 'challenges')
  end
  
  def history_disagreed
    respond_with(@prediction.challenges.disagreed_by_users, 
      each_serializer: ChallengeHistorySerializer,
      root: 'challenges')
  end
  
  def agree
    authorize_action_for(@prediction)
    @challenge = current_user.challenges.where(prediction: @prediction).first
    if @challenge
      @challenge.update(agree: true)
    else
      @challenge = current_user.challenges.create(prediction: @prediction, agree: true)
    end
    respond_with(@challenge)    
  end
  
  def disagree
    authorize_action_for(@prediction)
    @challenge = current_user.challenges.where(prediction: @prediction).first
    if @challenge
      @challenge.update(agree: false)
    else
      @challenge = current_user.challenges.create(prediction: @prediction, agree: false)
    end
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

  def comment
    authorize_action_for(@prediction)
    @comment = current_user.comments.create(prediction: @prediction, text: params[:comment][:text])
    respond_with(@comment, :location => api_comments_url)
  end
  
  def bs
    authorize_action_for(@prediction)
    
    @challenge = current_user.challenges.where(prediction: @prediction).first
    @challenge.update(bs: true)
    if not @challenge.is_own
      @challenge.prediction.request_for_bs
    else
      @challenge.prediction.revert
    end
    
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
    if derived_version < 2
      return params.require(:prediction).permit(:body, :expires_at, :resolution_date, :tag_list => [])
    else
      x = params.require(:prediction).permit(:body, :expires_at, :resolution_date, :tag_list)
      x['tag_list'] = params['tag_list']
      return x
    end
  end
  
  def prediction_update_params
    params.require(:prediction).permit(:resolution_date)
  end
end