require 'gcm'

namespace :apns do
    task push: :environment do
      pusher = Grocer.pusher(
        certificate: Rails.application.config.apns_certificate,
        gateway:     Rails.application.config.apns_gateway,
        port:        2195,
        retries:     3
      )
      gcm = GCM.new("AIzaSyDSuv3FpA4NtTXJivbsfh28vixLn55DrlI")

      predictions = Prediction.select("user_id, count(id) as total_predictions").
          unnotified.
          readyForResolution.
          group("user_id").
          order("user_id DESC")
      predictions.each do |p|
        if p.user.notification_settings.where(:setting => 'PUSH_EXPIRED').first.active == true
          p.user.apple_device_tokens.where(sandbox: Rails.application.config.apns_sandbox).each do |token|
            notification = Grocer::Notification.new(
              device_token:      token.token,
              alert:             "Showtime! Your prediction has expired, settle it.",
              badge:             p.user.alerts_count,
              custom: {
                "id": p.id,
                "type": 'p'
              }
            )
            pusher.push(notification)
          end
          if p.user.android_device_tokens.size > 0
            response = gcm.send_notification(p.user.android_device_tokens.pluck(:token), {data: {alert: "You have predictions ready for resolution", id: p.id, type: 'p'}, collapse_key: "expired_predictions"});
          end
        end
        p.user.predictions.expired.unnotified.update_all(push_notified_at: DateTime.now)
      end
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
                p.user.predictions.expired.unnotified.update_all(push_notified_at: DateTime.now)
            end
        end
    end

    # Process Apple feedback
    task feedback: :environment do
        feedback = Grocer.feedback(
          certificate: Rails.application.config.apns_certificate,
          gateway:     Rails.application.config.apns_gateway,
          port:        2195,
          retries:     3
        )

        feedback.each do |attempt|
            print attempt
            #print("token #{attempt.device_token}\n")
            #token = AppleDeviceToken.find_by_token(attempt.device_token)
            #if token && token.timestamp > token.created_at
            #     print("token #{token.token} unsubscribe\n")
            #     token.delete
            #end
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
