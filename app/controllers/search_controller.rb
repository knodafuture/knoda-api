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
    if derived_version < 2  
      respond_with(@users, each_serializer: UserSerializer, root: "users")
    else
      respond_with(@users, each_serializer: UserSerializer, root: false)
    end
  end

  def predictions
    limit = param_limit || 50
    @predictions = []
    @searchResults = Prediction.search params[:q], page: param_offset.to_i.fdiv(limit.to_i), per_page: limit, misspellings: {distance:2}, partial: true
    @searchResults.each do |p|
      m = p.to_model
      if !m.group_id or current_user.memberships.pluck(:group_id).include?(m.group_id)
        @predictions << m
      end
    end
    if derived_version < 2  
      respond_with(@predictions, each_serializer: PredictionFeedSerializer, root: "predictions")
    else
      respond_with(@predictions, each_serializer: PredictionFeedSerializerV2, root: false)
    end    
  end
end