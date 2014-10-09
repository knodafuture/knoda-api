class Api::ActivityfeedController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def index
    create_expired_activities()
    @activities = current_user.activities
    if derived_version < 3
      @activities = @activities.where("activity_type != 'INVITATION'")
    end
    if derived_version < 6
      @activities = @activities.where("activity_type != 'FOLLOWING'")
    end
    if derived_version < 7
      @activities = @activities.where("activity_type != 'COMMENT_MENTION' AND activity_type != 'PREDICTION_MENTION'")
    end
    case (params[:list])
      when 'unseen'
        @activities = @activities.unseen.order('created_at desc')
      else
        @activities = @activities.order('created_at desc')
    end
    if params[:filter]
      case (params[:filter].downcase)
        when 'invites'
          @activities = @activities.where(:activity_type => 'INVITATION')
        when 'comments'
          @activities = @activities.where(:activity_type => 'COMMENT')
        when 'expired'
          @activities = @activities.where(:activity_type => 'EXPIRED')
      end
    end

    @activities = @activities.id_lt(param_id_lt)

    if derived_version < 2
      respond_with(@activities.offset(param_offset).limit(param_limit),
        meta: pagination_meta(@activities),
        each_serializer: ActivitySerializer)
    elsif derived_version == 2
      respond_with(@activities.offset(param_offset).limit(param_limit),
        each_serializer: ActivitySerializer, root: false)
    elsif derived_version == 3
      respond_with(@activities.offset(param_offset).limit(param_limit),
        each_serializer: ActivitySerializerV3, root: false)
    else
      respond_with(@activities.offset(param_offset).limit(param_limit),
        each_serializer: ActivitySerializerV4, root: false)
    end

    mark_as_seen()
  end

  def seen
    current_user.activities.where(id: params[:ids][0].split(',')).update_all(seen: true)
    head :no_content
  end

private
  def create_expired_activities
    current_user.predictions.readyForResolution.notAlerted.each do |p|
      p.update(activity_sent_at: DateTime.now)
      current_user.activities.create!(user: current_user, prediction_id: p.id, title: "Showtime! Your prediction has expired, settle it.", prediction_body: p.body, activity_type: "EXPIRED");
    end
  end

  def mark_as_seen
    if params[:list] != 'unseen'
      current_user.activities.update_all(seen: true)
    end
  end
end
