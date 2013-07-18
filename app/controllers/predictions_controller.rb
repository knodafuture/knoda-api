class PredictionsController < ApplicationController
  before_action :set_prediction, only: [:show, :edit, :update, :destroy]
  respond_to :html
  
  authorize_actions_for Prediction, :only => [:index, :show, :create]

  def index
    if params[:tag]
      @predictions = current_user.predictions.tagged_with(params[:tag])
    else
      @predictions = current_user.predictions.all
    end
    respond_with(@predictions)
  end

  def show
    respond_with(@prediction)
  end

  def new
    @prediction = Prediction.new
  end

  def edit
  end

  def create
    @prediction = current_user.predictions.new(prediction_params)

    respond_to do |format|
      if @prediction.save
        format.html { redirect_to @prediction, notice: 'Prediction was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    authorize_action_for(@prediction) 
    respond_to do |format|
      if @prediction.update(prediction_params)
        format.html { redirect_to @prediction, notice: 'Prediction was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /predictions/1
  def destroy
    authorize_action_for(@prediction) 
    @prediction.destroy
    respond_to do |format|
      format.html { redirect_to predictions_url }
    end
  end

  private

  def set_prediction
    @prediction = Prediction.find(params[:id])
  end

  def prediction_params
    params.require(:prediction).permit(:user_id, :body, :expires_at, :outcome, :closed_as, :tag_list)
  end
end
