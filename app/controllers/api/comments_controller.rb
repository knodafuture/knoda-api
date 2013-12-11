class Api::CommentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  
  def index
    case (params[:list])
      when 'own'
        @comments = current_user.comments.order('created_at desc')
      when 'prediction'
        @comments = Comment.joins(:user).where(prediction_id: params[:prediction_id]).order('created_at asc')
      else
        @comments = Comment.recent
    end

    @comments = @comments.id_lt(param_id_lt)

    respond_with(@comments.offset(param_offset).limit(param_limit), 
      meta: pagination_meta(@comments))
  end
end