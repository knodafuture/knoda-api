namespace :test_data do
  task cp: :environment do
    puts ENV['expires']
    require 'open-uri'
    u = User.order('random() desc').first
    body = JSON.load(open("http://www.savageipsum.com/api"))['text']
    startTime = Time.now
    #switch
    endTime = Time.now.advance(:days => 21)

    #p = Prediction.create(:user => u, :body => body, :expires_at =>)
    #puts p.id
  end
end
