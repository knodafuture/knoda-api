json.challenges @challenges do | challenge |
	json.id challenge.id
	json.agree challenge.agree
	json.created_at challenge.created_at
	json.is_own challenge.is_own
	json.is_right challenge.is_right
	json.is_finished challenge.is_finished
	json.seen challenge.seen
	json.points_details challenge.points_details
	json.bs challenge.bs
	json.set! :prediction do
		json.id challenge.prediction.id
		json.body challenge.prediction.body
		json.outcome challenge.prediction.outcome
		json.expires_at challenge.prediction.expires_at
		json.created_at challenge.prediction.created_at
		json.closed_at challenge.prediction.closed_at
		json.short_url challenge.prediction.short_url
		json.resolution_date challenge.prediction.resolution_date
		json.agreed_count challenge.prediction.agreed_count
		json.disagreed_count challenge.prediction.disagreed_count
		json.comment_count challenge.prediction.comment_count
		json.market_size challenge.prediction.market_size
		json.prediction_market challenge.prediction.prediction_market
		json.user_id challenge.prediction.user_id
		json.username challenge.prediction.user.username
		json.user_avatar challenge.prediction.user.avatar_image
		json.expired challenge.prediction.expired
		json.settled challenge.prediction.settled
		json.is_ready_for_resolution challenge.prediction.is_ready_for_resolution
		json.resolution_date challenge.prediction.resolution_date
		json.tags challenge.prediction.tags, :id, :name	
	end
end
json.meta @meta