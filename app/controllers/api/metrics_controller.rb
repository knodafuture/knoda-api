class Api::MetricsController < ApplicationController
  skip_before_filter :authenticate_user_please!

  def index    
    users = { :current => User.count, :lag7 => User.where("created_at < :start_date",{start_date: 7.days.ago}).count}
    commentRatio = { :current => ((Comment.count.to_f) / (Prediction.count.to_f))}
    challengeRatio = { :current => (((Challenge.count - Prediction.count).to_f) / (Prediction.count.to_f))}
    p = Prediction.select("tags as name, count(*) as count").group("name")
    categories = []
    p.each do |tag|
      categories << {:name => tag.name[0], :count => tag.count}
    end
    render :json => {:userMetrics => users,  :commentRatio => commentRatio, :challengeRatio => challengeRatio, :status => "whatever", :categories => categories}
  end
end