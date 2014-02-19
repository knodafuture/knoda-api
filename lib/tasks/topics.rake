namespace :topics do
  
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

  task order: :environment do
    @t = Topic.find(:first, :conditions => [ "upper(name) = ?", 'SPORTS' ])
    @t.sort_order = 1
    @t.save
    @t = Topic.find(:first, :conditions => [ "upper(name) = ?", 'ENTERTAINMENT' ])
    @t.sort_order = 2
    @t.save
    @t = Topic.find(:first, :conditions => [ "upper(name) = ?", 'PERSONAL' ])
    @t.sort_order = 3
    @t.save
    @t = Topic.find(:first, :conditions => [ "upper(name) = ?", 'BUSINESS' ])
    @t.sort_order = 4
    @t.save    
    @t = Topic.find(:first, :conditions => [ "upper(name) = ?", 'WEATHER' ])
    @t.sort_order = 5
    @t.save
    @t = Topic.find(:first, :conditions => [ "upper(name) = ?", 'POLITICS' ])
    @t.sort_order = 6
    @t.save    
    @t = Topic.find(:first, :conditions => [ "upper(name) = ?", 'STOCKS' ])
    @t.sort_order = 7
    @t.save
    @t = Topic.find(:first, :conditions => [ "upper(name) = ?", 'FUNNY' ])
    @t.sort_order = 8
    @t.save
    @t = Topic.find(:first, :conditions => [ "upper(name) = ?", 'OTHER' ])
    @t.sort_order = 9
    @t.save
  end
end
