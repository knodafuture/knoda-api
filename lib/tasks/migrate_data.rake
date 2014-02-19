namespace :migrate_data do
  task tagsToArray: :environment do
    ActsAsTaggableOn::Tagging.joins(:tag).all.each do |t|
      p = Prediction.find(t.taggable_id)
      tagName = t.tag.name.upcase
      p.tags = [tagName]
      p.save
    end
  end
end