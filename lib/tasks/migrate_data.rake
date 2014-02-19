namespace :migrate_data do
  task tagsToArray: :environment do
    ActsAsTaggableOn::Tagging.joins(:tag).all.each do |t|
      p = Prediction.find(t.taggable_id)
      t = t.tag.name.upcase
      p.tags = [t]
      p.save
    end
  end
end