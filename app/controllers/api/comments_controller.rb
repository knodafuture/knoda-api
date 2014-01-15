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

  def create
    @comment = current_user.comments.create(comment_params)
    show()
  end

  def show
    respond_with(@comment)
  end    

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:prediction_id, :text)
    end    

end