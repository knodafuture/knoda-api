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
end