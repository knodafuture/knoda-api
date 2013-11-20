namespace :apns do

    task push: :environment do
      pusher = Grocer.pusher(
        certificate: "#{Rails.root}/certs/certificate_production.pem",
        gateway:     "gateway.push.apple.com",
        port:        2195,                     # optional
        retries:     3                         # optional
      )

      notification = Grocer::Notification.new(
        device_token:      "d62ce42a25fc969711b6475a82910dedc4987207bdbac84e028d16fbadc4a403",
        alert:             "Hello from Grocer!",
        badge:             42,
        sound:             "siren.aiff",         # optional
        expiry:            Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
        identifier:        1234,                 # optional
        content_available: true                  # optional; any truthy value will set 'content-available' to 1
      )

      pusher.push(notification)      
    end

    # Export notifications
    task export: :environment do
        sandbox = ENV['sandbox'] == "yes"

        predictions = Prediction.select("user_id, count(id) as total_predictions").
            unnotified.
            expired.
            group("user_id").
            order("user_id DESC")

        predictions.each do |p|
            next unless p.user.notifications
		
            p.user.apple_device_tokens.where(sandbox: sandbox).each do |token|
                print("#{token.token} #{p.total_predictions} #{p.user.alerts_count}\n")
            end

            if not sandbox
                p.user.predictions.expired.unnotified.update_all(notified_at: DateTime.now)
            end
        end
    end

    # Process Apple feedback
    task feedback: :environment do
        feedback = Grocer.feedback(
            certificate: "#{Rails.root}/certs/certificate_production.pem",
            gateway:     "feedback.push.apple.com",
            retries:     3,
        )

        feedback.each do |attempt|
            print("token #{attempt.device_token}\n")

            token = AppleDeviceToken.find_by_token(attempt.device_token)
            if token && token.timestamp > token.created_at
                 print("token #{token.token} unsubscribe\n")
                 token.delete			
            end
        end
    end
    
    # Process failed notifications
    task process_failed: :environment do
       unless ENV['file']
           print("Please specify file\n")
           exit 1
       end

       t = DateTime.now

       File.open(ENV['file']).read.each_line do |line|
           line = line.chomp
           if line.length > 1
              print("-> #{line}\n");
              token = AppleDeviceToken.find_by_token(line)
              if token && token.created_at < t
                  print("token #{token.token} unsubscribe\n")
                  token.delete
              end
           end
       end
    end
end
