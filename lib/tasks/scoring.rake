namespace :scoring do

  task top10: :environment do
    ScoredPrediction.delete_all
    predictions = Prediction.find_by_sql("select predictions.*, ((cml.commentCount*2) + chl.challengeCount - ((now()::date - predictions.created_at::date)*4)) as score from predictions, (select count(*) as challengeCount, prediction_id from challenges group by prediction_id) chl, (select count(*) as commentCount, prediction_id from comments group by prediction_id) cml WHERE predictions.id = chl.prediction_id AND predictions.id = cml.prediction_id AND group_id is null ORDER BY score DESC LIMIT 10")
    predictions.each do |p|
      sp = ScoredPrediction.new
      sp.prediction_id = p.id
      sp.body = p.body
      sp.expires_at = p.expires_at
      sp.username = p.user.username
      if p.user.avatar_image != nil
        sp.avatar_image = p.user.avatar_image[:small]
      end
      sp.agree_percentage = p.agree_percentage
      sp.save
    end
  end
end
