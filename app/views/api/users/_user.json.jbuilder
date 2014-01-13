json.id user.id
json.username user.username
json.email user.email
json.created_at user.created_at
json.avatar_image user.avatar_image
json.verified_account user.verified_account
json.points user.points
json.won user.won
json.lost user.lost
json.winning_percentage user.winning_percentage
json.streak user.streak_as_text
json.total_predictions user.predictions.count
json.test user.won
if user.id == current_user.id
	json.alerts user.alerts_count
	json.badges user.badges.unseen.count
	json.notifications user.notifications
end