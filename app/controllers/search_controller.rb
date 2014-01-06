class Api::SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  
  def users
    limit = param_limit || 5
    @users = []
    @searchResults = User.search params[:q], fields: [:username], page: param_offset.to_i.fdiv(limit.to_i), per_page: limit, misspellings: {distance:1}, partial: true
    @searchResults.each do |u|
      @users << u.to_model
    end
    respond_with(@users, each_serializer: UserSerializer, root: "users")
  end

  def predictions
    limit = param_limit || 50
    @predictions = []
    @searchResults = Prediction.search params[:q], page: param_offset.to_i.fdiv(limit.to_i), per_page: limit, misspellings: {distance:2}, partial: true
    @searchResults.each do |p|
      @predictions << p.to_model
    end
    respond_with(@predictions, each_serializer: PredictionFeedSerializer, root: "predictions")
  end
end