class Api::PredictionsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_prediction,
    only: [:show, :edit, :update, :destroy, :agree, :disagree, :realize, :unrealize]

  respond_to :json

  authorize_actions_for Prediction

  def index
    if params[:tag]
      @predictions = current_user.predictions.tagged_with(params[:tag])
    else
      @predictions = current_user.predictions.all
    end
    respond_with(@predictions) do |format|
      format.json { render json: @predictions}
    end
  end

  def show
    respond_with(@prediction) do |format|
      format.json { render json: @prediction}
    end
  end

  def create
    @prediction = current_user.predictions.new(prediction_params)

    respond_with(@prediction) do |format|
      if @prediction.save
        format.json { render json: @prediction, status: 201}
      else
        format.json { render json: @prediction.errors, status: 422 }
      end
    end
  end

  def update
    respond_with(@prediction) do |format|
      if @prediction.update(prediction_params)
        format.json { head :no_content }
      else
        format.json { render json: @prediction.errors, status: 422 }
      end
    end
  end

  def destroy
    @prediction.destroy
    respond_with(@prediction) do |format|
      format.json { head :no_content }
    end
  end

  def agree
    vote(true)
  end

  def disagree
    vote(false)
  end
  
  def realize
    close_prediction(true)
  end
  
  def unrealize
    close_prediction(false)
  end

  private
  
  def close_prediction(outcome)
    @prediction.outcome = outcome
    @prediction.closed_at = Time.now
    if @prediction.save
      respond_with(@prediction)
    else
      render json: @prediction.errors, status: 422
    end
  end

  def vote(is_agreed)
    @challenge = current_user.challenges.new({
      :prediction => @prediction,
      :agree => is_agreed
    });

    if @challenge.save
      respond_with @challenge
    else
      render json: @challenge.errors, status: 422
    end
  end

  private

  def set_prediction
    @prediction = Prediction.find(params[:id])
  end

  def vote_params
    params.permit(:agree)
  end

  def prediction_params
    params.require(:prediction).permit(:user_id, :body, :expires_at, :outcome, :closed_as, :tag_list => [])
  end
end
