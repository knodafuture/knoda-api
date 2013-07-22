class Api::PredictionsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_prediction,
    only: [:show, :edit, :update, :destroy, :agree, :disagree, :realize, :unrealize]

  respond_to :json

  authorize_actions_for Prediction, :only => [:index, :create, :show]
  def index
    if params[:tag]
      @predictions = current_user.predictions.tagged_with(params[:tag])
    elsif params[:recent]
      @predictions = Prediction.recent
    elsif params[:user_recent]
      @predictions = Prediction.recent_by_user_id(current_user.id)
    elsif params[:expired]
      @predictions = Prediction.closed_by_user_id(current_user.id)
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
    authorize_action_for(@prediction)
    respond_with(@prediction) do |format|
      if @prediction.update(prediction_params)
        format.json { head :no_content }
      else
        format.json { render json: @prediction.errors, status: 422 }
      end
    end
  end

  def destroy
    authorize_action_for(@prediction)
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
  
  def set_points_for_prediction(prediction, outcome)
    market_size = prediction.challenges.count
    
    # Market size points
    market_size_points = case prediction.challenges.count
    when 0..5
      0
    when 6..20
      1
    when 21..100
      2
    when 101..500
      3
    when 501..(1.0/0.0)
      4
    end
    
    # Prediction market points
    prediction_market_points = case prediction.prediction_market
    when 0.0..15.00
      5
    when 15.00..30.00
      4
    when 30.00..50.00
      3
    when 50.00..75.00
      2
    when 75.00..95.00
      1
    when 95.00..100.00
      0
    end
    
    # Outcome points
    outcome_points = outcome ? 1 : 0
    
    # Add points to users who agreed/disagreed
    prediction.challenges.each do |challenge|
      challenge.user.points += prediction_market_points + outcome_points
      challenge.user.save!
    end
    
    # Add points to user who created the prediction
    prediction.user.points += market_size_points + prediction_market_points + outcome_points
    prediction.user.save!    
  end

  def close_prediction(outcome)
    authorize_action_for(@prediction)
    @prediction.outcome = outcome
    @prediction.closed_at = Time.now
    if @prediction.save
      @prediction.user.outcome_badges    
      
      set_points_for_prediction(@prediction, outcome)
                    
      respond_with(@prediction)
    else
      render json: @prediction.errors, status: 422
    end
  end

  def vote(is_agreed)
    authorize_action_for(@prediction)
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

  def set_prediction
    @prediction = Prediction.find(params[:id])
  end

  def vote_params
    params.permit(:agree)
  end

  def prediction_params
    params.require(:prediction).permit(:user_id, :body, :expires_at, :outcome, :closed_at, :tag_list => [])
  end
end
