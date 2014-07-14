
#input :cp minutes = 'x' amount = 'y'

namespace :test_data do
  task cp: :environment do
  mins = ENV['mins'].to_i
  amount = ENV['amount'].to_i
    require 'open-uri'
    randyBacon = 0
    amount.times do |p|
      #USER
      u = User.order('random() desc').first
      #CATEGORY
      cat = ['SPORTS']
      #IPSUM
      randyBacon = rand(4)
      case randyBacon
      when 0
        body = JSON.load(open("http://www.savageipsum.com/api"))['text']
      when 1
        body = JSON.load(open("http://baconipsum.com/api/?type=all-meat&sentences=1"))[0]
      when 2
        body = JSON.load(open("http://skateipsum.com/get/1/0/JSON"))[0]
        body = body[0..100]
      when 3
        body = JSON.load(open("http://hipsterjesus.com/api/?type=hipster-centric&paras=1&html=false"))['text']
        body = body[0..100]
      else
      end
      #TIME
      startTime = Time.now
      endTime = Time.now.advance(:minutes => mins)
      expires = Time.at((endTime.to_f - startTime.to_f)*rand + startTime.to_f)
      #CREATE PREDICITON
      p = Prediction.create(:user => u, :body => body, :expires_at =>expires, :tags => cat, :resolution_date => expires)
    end

  end

#input :cc predictionid = 'x' amount = 'y'

  task cc: :environment do
    predictionid = ENV['predictionid'].to_i
    amount = ENV['amount'].to_i
    require 'open-uri'
    amount.times do |c|
      time = Time.now
      #USER
      u = User.order('random() desc').first
      #IPSUM
      randyBacon = rand(4)
      case randyBacon
      when 0
        body = JSON.load(open("http://www.savageipsum.com/api"))['text']
      when 1
        body = JSON.load(open("http://baconipsum.com/api/?type=all-meat&sentences=1"))[0]
      when 2
        body = JSON.load(open("http://skateipsum.com/get/1/0/JSON"))[0]
        body = body[0..100]
      when 3
        body = JSON.load(open("http://hipsterjesus.com/api/?type=hipster-centric&paras=1&html=false"))['text']
        body = body[0..100]
      else
      end
      #CREATE COMMENT
      c = Comment.create(:user => u, :prediction_id => predictionid, :text => body)
    end
  end

  #input :cv predictionid = 'x' agree = 'y' amount = 'z'

  task cv: :environment do
    predictionid = ENV['predictionid'].to_i
    amount = ENV['amount'].to_i
    if ENV['agree'] == "random"
      random_bool = [true, false].sample
      agree = random_bool
    elsif ENV['agree'] == "yes"
      agree = true
    else
      agree = false
    end
    require 'open-uri'
    amount.times do |v|
      #USER
      u = User.order('random() desc').first
      #CREATECHALLENGE
      v = Challenge.create(:user => u, :prediction_id => predictionid, :agree => agree)
    end
  end
end
