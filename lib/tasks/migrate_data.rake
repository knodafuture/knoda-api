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

  task migrate_owly: :environment do
    Prediction.where("short_url ilike ?", "%ow.ly%").each do |p|
      su = ShortUrl.create(:long_url => "#{Rails.application.config.knoda_web_url}/predictions/#{p.id}/share")
      su.slug = p.short_url.split('/')[3]
      su.save
      p.update!(:short_url => p.short_url.gsub('ow.ly', 'knoda.co'))
    end
    Group.where("share_url ilike ?", "%ow.ly%").each do |g|
      su = ShortUrl.create(:long_url => "#{Rails.application.config.knoda_web_url}/groups/join?id=#{g.share_id}")
      su.slug = g.share_url.split('/')[3]
      su.save
      g.update!(:share_url => g.share_url.gsub('ow.ly', 'knoda.co'))
    end
  end

  task add_push_followers: :environment do
    User.all.each do |u|
      u.notification_settings.create!(:user => u, :setting => 'PUSH_FOLLOWINGS',  :display_name => 'Followers', :description => 'Notify me when another Knoda user starts following me.',:active => true)
    end
  end

  task init_rivals: :environment do
    Sidekiq.configure_client do |config|
      config.redis = { size: 1, :namespace => 'sidekiq-knoda' }
    end
    User.all.each do |u|
      FindRivals.perform_async(u.id)
    end
  end

  task init_hashtags: :environment do
    Prediction.select(:body).all.each do |p|
      tags = p.body.scan(/#(\w+)/).flatten
      tags.each do |t|
        ht = Hashtag.where(:tag => t).first_or_initialize
        ht.used = ht.used + 1
        ht.save
      end
    end
    Comment.select(:text).all.each do |c|
      tags = c.text.scan(/#(\w+)/).flatten
      tags.each do |t|
        ht = Hashtag.where(:tag => t).first_or_initialize
        ht.used = ht.used + 1
        ht.save
      end
    end
  end

  task add_push_mentions: :environment do
    User.all.each do |u|
      u.notification_settings.create!(:user => u, :setting => 'PUSH_MENTIONS',  :display_name => 'Mentions', :description => 'Notify me when another Knoda user mentions me in a prediction.',:active => true)
    end
  end
end
