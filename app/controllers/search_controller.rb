class Api::SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  
  def users
    @users = User.search params[:q], page: param_offset.to_i.fdiv(param_limit.to_i), per_page: param_limit, misspellings: {distance:2}
    respond_with(@users, each_serializer: UserSerializer)
  end

  def predictions
    @predictions = Prediction.search params[:q], page: param_offset.to_i.fdiv(param_limit.to_i), per_page: param_limit, misspellings: {distance:2}
    respond_with(@predictions, each_serializer: PredictionFeedSerializer)    
  end
end