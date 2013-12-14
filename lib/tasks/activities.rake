namespace :activities do

  task generate: :environment do
    Challenge.joins(:prediction).where("is_finished IS TRUE").each do |c|
      if c.is_own
        title = (c.agree == c.prediction.outcome) ? "You won #{c.total_points} points for" : "You lost but still got #{c.total_points} points for your prediction"
      else
        title = (c.agree == c.prediction.outcome) ? "Your vote was right and you earned #{c.total_points} points" : "Your vote was wrong but you earned #{c.total_points} points"
      end
      activity_type = (c.agree == c.prediction.outcome) ? 'WON' : 'LOST'      
      Activity.create!(user: c.user, prediction_id: c.prediction.id, title: title, prediction_body: c.prediction.body, activity_type: activity_type, created_at: c.prediction.closed_at, seen: c.seen);
    end
  end
end
