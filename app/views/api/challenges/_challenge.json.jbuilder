json.id challenge.id
json.agree challenge.agree
json.created_at challenge.created_at
json.is_own challenge.is_own
json.is_right challenge.is_right
json.is_finished challenge.is_finished
json.seen challenge.seen
json.points_details challenge.points_details
json.bs challenge.bs
json.user json.partial! 'api/users/user', user: challenge.user
json.prediction challenge.prediction