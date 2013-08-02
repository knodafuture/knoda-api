namespace :reports do
  desc "Generate and send daily report"
  task daily: :environment do
    # get new users
    users = User.where("created_at >= ?", DateTime.now - 24.hours).order("created_at")
    
    # get new predictions
    predictions = Prediction.where("created_at >= ?", DateTime.now - 24.hours).order("created_at")
    
    # Send mail
    ReportsMailer.daily(users, predictions).deliver
  end
end
