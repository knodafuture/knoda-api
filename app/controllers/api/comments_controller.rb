class Api::CommentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  
  def index
    case (params[:list])
      when 'own'
        @comments = current_user.comments
      when 'prediction'
        @comments = Comment.joins(:user).where(prediction_id: params[:prediction_id])
      else
        @comments = Comment.recent
    end
    respond_with(@comments.offset(param_offset).limit(param_limit), 
      meta: pagination_meta(@comments))
  end
end