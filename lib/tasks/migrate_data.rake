namespace :migrate_data do
  task tagsToArray: :environment do
    ActsAsTaggableOn::Tagging.joins(:tag).all.each do |t|
      p = Prediction.find(t.taggable_id)
      p.tags = [t.tag.name]
      p.save
    end
  end
end