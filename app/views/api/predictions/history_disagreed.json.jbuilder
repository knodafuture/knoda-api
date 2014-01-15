json.challenges @challenges do |c|
  json.user_id c.user_id
  json.agree c.agree
  json.username c.user.username
end