namespace :activities do

  task generate: :environment do
    Challenge.notifications.each do |c|
      puts "#{c.id} - #{c.seen}"
    end
    #predictions = Prediction.readyForResolution #.withoutExpiredActivity
    #predictions.each do |p|
    #  Activity.create!(user: p.user, prediction_id: p.id, body: 'Your prediction has expired. Please settle the outcome of ' + p.body, activity_type: 'EXPIRED')
    #end
  end
end
