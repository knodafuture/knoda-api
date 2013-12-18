class Api::MetricsController < ApplicationController
  skip_before_filter :authenticate_user_please!

  def index    
    users = { :current => User.count, :lag7 => User.where("created_at < :start_date",{start_date: 7.days.ago}).count}
    commentRatio = { :current => ((Comment.count.to_f) / (Prediction.count.to_f))}
    challengeRatio = { :current => (((Challenge.count - Prediction.count).to_f) / (Prediction.count.to_f))}
    p = Prediction.tag_counts_on(:tags).order('tags_count DESC')
    #Tag.find(:all,:group => 'name',:order => 'name asc')
    #tagGrouping = Prediction.tags_count()
    #tagGrouping.each do |t|
    #  puts t
    #end
    render :json => {:userMetrics => users,  :commentRatio => commentRatio, :challengeRatio => challengeRatio, :status => "whatever", :categories => p}
  end
end