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

  task activitiesv4: :environment do
    # Comment Activities
    Activity.where(:activity_type => 'COMMENT').where('comment_body is null').each do |a|
      prediction = Prediction.find(a.prediction_id)
      lastComment = Comment.where(:prediction_id => a.prediction_id).order('created_at desc').first
      if prediction and lastComment
        a.comment_body = lastComment.text
        if lastComment.user.avatar_image
          a.image_url = lastComment.user.avatar_image[:small]
        end
        if a.user_id == prediction.user_id
          a.title = lastComment.notification_title(true)
        else
          a.title = lastComment.notification_title(false)
        end
        a.save!
      end
    end
    #Group Invitations
    Activity.where(:activity_type => 'INVITATION').where('image_url is null').each do |a|
      invitation = Invitation.where(:code => a.invitation_code).first
      if invitation.group.avatar_image
        a.image_url = invitation.group.avatar_image[:small]
      end
      a.save!
    end
    #Expired Activities
    Activity.where(:activity_type => 'EXPIRED').where(:title => 'Your prediction has expired. Please settle the outcome').update_all(:title => 'Showtime! Your prediction has expired, settle it.')
    #Won activities
    Activity.where(:activity_type => 'WON').where('image_url is null').order('id desc').find_each(:batch_size => 500) do |a|
      challenge = Challenge.where(:prediction_id => a.prediction_id, :user_id => a.user_id).first
      if challenge
        a.title = challenge.notification_title
        a.image_url = challenge.notification_image_url
        a.save!
      end
    end
    #Lost activities
    Activity.where(:activity_type => 'LOST').where('image_url is null').order('id desc').find_each(:batch_size => 500) do |a|
      challenge = Challenge.where(:prediction_id => a.prediction_id, :user_id => a.user_id).first
      if challenge
        a.title = challenge.notification_title
        a.image_url = challenge.notification_image_url
        a.save!
      end
    end
  end

  task co_to_owly: :environment do
    Prediction.where("short_url ilike ?", "%knoda.co%").each do |p|
      p.update!(:short_url => p.short_url.gsub('knoda.co', 'ow.ly'))
    end
    Group.where("share_url ilike ?", "%knoda.co%").each do |p|
      p.update!(:share_url => p.share_url.gsub('knoda.co', 'ow.ly'))
    end    
  end
end
