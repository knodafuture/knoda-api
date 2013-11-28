class Api::MetricsController < ApplicationController
  skip_before_filter :authenticate_user_please!

  def index    
    current = User.count
    lag7 = User.where("created_at < :start_date",{start_date: 7.days.ago}).count
    users = { :current => current, :lag7 => lag7}
    render :json => {:userMetrics => users, :status => "whatever"}
  end
end