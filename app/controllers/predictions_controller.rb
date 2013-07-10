class PredictionsController < ApplicationController
  before_filter :require_login
  before_action :set_prediction, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  # GET /predictions
  # GET /predictions.json
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

  # GET /predictions/1
  # GET /predictions/1.json
  def show
    respond_with(@prediction) do |format|
      format.json { render json: @prediction}
    end
  end

  # GET /predictions/new
  def new
    @prediction = Prediction.new
  end

  # GET /predictions/1/edit
  def edit
  end

  # POST /predictions
  # POST /predictions.json
  def create
    @prediction = current_user.predictions.new(prediction_params)

    respond_to do |format|
      if @prediction.save
        format.html { redirect_to @prediction, notice: 'Prediction was successfully created.' }
        format.json { render action: 'show', status: :created, location: @prediction }
      else
        format.html { render action: 'new' }
        format.json { render json: @prediction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /predictions/1
  # PATCH/PUT /predictions/1.json
  def update
    respond_to do |format|
      if @prediction.update(prediction_params)
        format.html { redirect_to @prediction, notice: 'Prediction was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @prediction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /predictions/1
  # DELETE /predictions/1.json
  def destroy
    @prediction.destroy
    respond_to do |format|
      format.html { redirect_to predictions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prediction
      @prediction = Prediction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prediction_params
      params.require(:prediction).permit(:user_id, :title, :text, :expires_at, :closed, :closed_at, :closed_as, :tag_list)
    end

    def require_login
      unless current_user
        flash[:error] = "You must be logged in to access this section"
        redirect_to new_user_session_url # Prevents the current action from running
      end
    end

end
