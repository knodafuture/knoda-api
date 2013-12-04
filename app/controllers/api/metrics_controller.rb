class Api::MetricsController < ApplicationController
  skip_before_filter :authenticate_user_please!

  def index    
    users = { :current => User.count, :lag7 => User.where("created_at < :start_date",{start_date: 7.days.ago}).count}
    interaction = { :current => ((Comment.count + Challenge.count) /Prediction.count)}
    render :json => {:userMetrics => users,  :interactionMetrics => interaction, :status => "whatever"}
  end
end