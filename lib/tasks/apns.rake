namespace :apns do
  desc "TODO"
  task send: :environment do
    pusher = Grocer.pusher(
	  certificate: "#{Rails.root}/certs/certificate.pem", 
	)

	predictions = Prediction.select("user_id, count(id) as total_predictions").
		where("notified_at is null and is_closed is false and expires_at < now()").
		group("user_id").
		order("user_id DESC")

	predictions.each do |p|
		message = case p.total_predictions
			when 1
				"You have new expired prediction"
			else
				"You have #{p.total_predictions} new expired predictions"
		end

		p.user.apple_device_tokens.each do |token|
			notification = Grocer::Notification.new(
				device_token: token.token,
				alert: message,
				badge: p.user.alerts_count,
			)

			Rails.logger.debug "sending notification to #{p.user.username} with message: #{message}"

			pusher.push(notification)
		end

		p.user.predictions.where("notified_at is null and is_closed is false and expires_at < now()").
			update_all(notified_at: DateTime.now())
	end
  end
end
