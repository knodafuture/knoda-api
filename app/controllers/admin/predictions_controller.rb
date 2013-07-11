class Admin::PredictionsController < Admin::AdminController
  before_action :set_prediction, only: [:update]
  
  def index
    list = params[:list] || 'expiring'
    @predictions = case list
      when 'expiring' then Prediction.order("expires_at DESC")
      when 'new'      then Prediction.order("created_at DESC")
      when 'top'      then Prediction.order("created_at DESC") # TODO: order by votes count
    end
  end
  
  def update
    
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prediction
      @prediction = Prediction.find(params[:id])
    end
end
