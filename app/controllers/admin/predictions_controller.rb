class Admin::PredictionsController < Admin::AdminController
  before_action :set_prediction, only: [:update]

  def index
    list = params[:list] || 'expiring'
    @predictions =
      case list
      when 'expiring'
        Prediction.order("expires_at DESC")
      when 'new'
        Prediction.order("created_at DESC")
      when 'top'
        Prediction.order("created_at DESC") # TODO: order by votes count
      end
  end

  def update

  end

  private

  def set_prediction
    @prediction = Prediction.find(params[:id])
  end
end
