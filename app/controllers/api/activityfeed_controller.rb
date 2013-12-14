class Api::ActivityfeedController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def index
    puts current_user.predictions.readyForResolution.size
    current_user.predictions.readyForResolution.notAlerted.each do |p|
      p.update(activity_sent_at: DateTime.now)
      current_user.activities.create!(user: current_user, prediction_id: p.id, title: "Your prediction has expired. Please settle the outcome", prediction_body: p.body, activity_type: "EXPIRED");
    end

    case (params[:list])
      when 'unseen'
        @activities = current_user.activities.unseen.order('created_at desc')
      else
        @activities = current_user.activities.order('created_at desc')
    end
    @activities = @activities.id_lt(param_id_lt)
    
    respond_with(@activities.offset(param_offset).limit(param_limit), 
      meta: pagination_meta(@activities),
      each_serializer: ActivitySerializer)
  end

  def seen
    current_user.activities.where(id: params[:ids][0].split(',')).update_all(seen: true)
    head :no_content
  end  

end  