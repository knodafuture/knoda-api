namespace :migrate_data do

  task fix_2014_05_05: :environment do
    predictions = Prediction.find_by_sql("select * from predictions where is_closed = true and id in (select prediction_id from challenges where is_finished = false) order by created_at;")
    predictions.each do |p|
      p.challenges.each do |c|
        if c.is_finished == false
          puts "I plan on closing challenge #{c.id} for prediction #{p.id}"
          c.close
        end
      end
      puts "Final close on prediction #{p.id}"
      PredictionClose.new.async.perform(p.id)
    end
  end

  task missing_prediction_images: :environment do
    Sidekiq.configure_client do |config|
      config.redis = { size: 1, :namespace => 'sidekiq-knoda' }
    end
    predictions = Prediction.where(:shareable_image_updated_at => nil).order('created_at desc').limit(100)
    predictions.each do |p|
      PredictionImageWorker.perform_async(p.id)
    end
  end

  task missing_notification_settings: :environment do
      users = User.all
      users.each do |user|
        if user.notification_settings.count == 0
          user.update_notification_settings
        end
      end
  end
end
