class Api::PredictionsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_prediction, :except => [:index, :create]
  after_action :after_close, only: [:realize, :unrealize]
  skip_before_filter :authenticate_user_please!, only: [:index]
  respond_to :json

  authorize_actions_for Prediction, :only => [:create, :show]

  def index
    if params[:challenged]
      @predictions = []
      predictionIds = []
      if derived_version < 5
        challenges = current_user.challenges.ownedAndPicked
      else
        challenges = current_user.challenges.picks
      end
      if param_id_lt
        challenges = challenges.where('challenges.id < ?', param_id_lt)
      end
      challenges = challenges.offset(param_offset).limit(param_limit)
      challenges.each do |c|
        predictionIds << c.prediction_id
      end
      challengeHash = Hash[predictionIds.map.with_index.to_a]
      @predictions = Prediction.includes(:challenges, :comments).where(:id => predictionIds).to_a.sort!{|p1,p2| challengeHash[p1.id] <=> challengeHash[p2.id] }
      respond_with(@predictions, each_serializer: PredictionFeedSerializerV2, root: false)
    else
      current_user_id = nil
      if current_user
        current_user_id = current_user.id
      end

      if params[:tag]
        @predictions = Prediction.includes(:challenges, :comments).recent.latest.visible_to_user(current_user_id).where("'#{params[:tag]}' = ANY (tags)")
      elsif params[:recent]
        @predictions = Prediction.includes(:challenges, :comments).recent.latest.visible_to_user(current_user_id)
      elsif params[:social]
        if current_user
          @predictions = Prediction.includes(:challenges, :comments).recent.latest.visible_to_user(current_user_id).by_leaders(current_user_id)
        else
          @predictions = Prediction.where("1 = 2")
        end
      else
        if current_user
          @predictions = current_user.predictions.order('created_at desc')
        else
          @predictions = Prediction.where("1 = 2")
        end
      end
      @predictions = @predictions.id_lt(param_id_lt)

      if derived_version < 2
        respond_with(@predictions.offset(param_offset).limit(param_limit),
          each_serializer: PredictionFeedSerializer,
          meta: pagination_meta(@predictions))
      else
        respond_with(@predictions.offset(param_offset).limit(param_limit),
          each_serializer: PredictionFeedSerializerV2, root: false)
      end
    end
  end

  def create
    @prediction = current_user.predictions.create!(prediction_create_params)
    if derived_version >= 2
      @prediction.reload
      serializer = PredictionFeedSerializerV2
    else
      serializer = PredictionFeedSerializer
    end
    respond_with(@prediction, serializer: serializer)
  end

  def update
    authorize_action_for(@prediction)
    p = prediction_update_params
    p[:activity_sent_at] = nil
    p[:push_notified_at] = nil
    @prediction.update(p)
    Activity.where(user_id: @prediction.user.id, prediction_id: @prediction.id, activity_type: 'EXPIRED').delete_all
    if derived_version >= 2
      serializer = PredictionFeedSerializerV2
    else
      serializer = PredictionFeedSerializer
    end
    render json: @prediction, serializer: serializer, status: 200
  end

  def show
    authorize_action_for(@prediction)
    if derived_version >= 2
      serializer = PredictionFeedSerializerV2
    else
      serializer = PredictionFeedSerializer
    end
    respond_with(@prediction, serializer: serializer)
  end

  def history_agreed
    if derived_version < 2
      respond_with(@prediction.challenges.agreed_by_users,
        each_serializer: ChallengeHistorySerializer,
        root: 'challenges')
    else
      respond_with(@prediction.challenges.agreed_by_users,
        each_serializer: ChallengeHistorySerializer,
        root: false)
    end
  end

  def history_disagreed
    if derived_version < 2
      respond_with(@prediction.challenges.disagreed_by_users,
        each_serializer: ChallengeHistorySerializer,
        root: 'challenges')
    else
      respond_with(@prediction.challenges.disagreed_by_users,
        each_serializer: ChallengeHistorySerializer,
        root: false)
    end
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
      if derived_version >= 2
        serializer = PredictionFeedSerializerV2
      else
        serializer = PredictionFeedSerializer
      end
      respond_with(@prediction, serializer: serializer)
    else
      render json: @prediction.errors, status: 422
    end
  end

  def unrealize
    authorize_action_for(@prediction)
    if @prediction.close_as(false)
      if derived_version >= 2
        serializer = PredictionFeedSerializerV2
      else
        serializer = PredictionFeedSerializer
      end
      respond_with(@prediction, serializer: serializer)
    else
      respond_with(@prediction.errors, status: 422)
    end
  end

  def comment
    if derived_version < 2
      authorize_action_for(@prediction)
      @comment = current_user.comments.create(prediction: @prediction, text: params[:comment][:text])
      respond_with(@comment, :location => api_comments_url)
    end
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
        p = params.require(:prediction).permit(:body, :expires_at, :resolution_date, :tag_list => [])
        p[:tags] = p[:tag_list]
        p.delete :tag_list
        return p
      else
        return params.permit(:body, :expires_at, :resolution_date, :group_id, :tags => [])
      end
    end

    def prediction_update_params
      if derived_version < 2
        return params.require(:prediction).permit(:resolution_date)
      else
        return params.permit(:resolution_date)
      end
    end

    def rebuild_leaderboard
      if @prediction.group
        Group.rebuildLeaderboards(@prediction.group)
      end
    end

    def after_close
      PredictionClose.perform_async(@prediction.id)
    end
end
