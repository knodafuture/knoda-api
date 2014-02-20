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
    
    if param_id_gt
      @comments = @comments.id_gt(param_id_gt)
    end

    if derived_version < 2        
      respond_with(@comments.offset(param_offset).limit(param_limit), meta: pagination_meta(@comments))
    else
      respond_with(@comments.offset(param_offset).limit(param_limit), root: false)      
    end
  end

  def create
    @comment = current_user.comments.create(comment_params)
    respond_with(@comment, :location => "#{api_comments_url}/#{@comment.id}.json")
  end

  def show
    respond_with(@comment, :location => "#{api_comments_url}/#{@comment.id}.json")
  end    

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:prediction_id, :text)
    end    

end