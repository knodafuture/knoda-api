namespace :topics do
  desc "TODO"
  task refresh: :environment do
    @topics = [
      'Sports',
      'Entertainment',
      'Stocks',
      'Weather',
      'Personal',
      'Social',
      'Funny',
      'TBD'
    ]
    
    Topic.update_all(hidden: true)
    
    @topics.each do |topic_name|
      puts "adding '#{topic_name}'"
      
      t = Topic.where(name: topic_name).first
      if t.nil?
        Topic.create(name: topic_name, hidden: false)
      else
        t.update(hidden: false)
      end
    end
  end

end
