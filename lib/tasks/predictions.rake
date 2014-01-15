namespace :predictions do
  task generateTestData: :environment do
  	i = 0;
  	50.times do
  		i = i + 1
  		user = User.first(:order => "RANDOM()")
  		Prediction.create!(:user => user, :body => "Random prediction ##{i}", :expires_at => Time.now + 1.hour, :resolution_date => Time.now + 2.hours, :tag_list => 'OTHER')
  	end
  end
end