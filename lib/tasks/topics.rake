namespace :topics do
  desc "TODO"
  task refresh: :environment do
    @topics = []
    
    File.open("#{Rails.root}/data/topics.txt") do |f|
      f.each do |line|      
        line.strip!
         
        unless line =~ /\#/ || line.empty?
          @topics << line
        end
      end
    end
    
    unless @topics.count
      puts "Please specify the topic list"
      exit
    end
    
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
