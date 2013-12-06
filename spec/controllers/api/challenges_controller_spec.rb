require 'spec_helper'

describe Api::ChallengesController do  
  let(:topic) {FactoryGirl.create(:topic)}
  let(:user1) {FactoryGirl.create(:user)}
  let(:user2) {FactoryGirl.create(:user)}
  let(:user1_prediction) {user1.predictions.build(body: "body1", expires_at: DateTime.now + 10.days, tag_list: [topic.name], resolution_date: DateTime.now)}
  let(:user2_prediction) {user2.predictions.build(body: "body2", expires_at: DateTime.now + 10.days, tag_list: [topic.name], resolution_date: DateTime.now)}
  let(:user1_token) {user1.authentication_token}
  let(:user2_token) {user2.authentication_token}
  
  describe "GET challenges.json" do
    it "should return user1 predictions" do
      user1.reset_authentication_token!
      user1.save
      user1_prediction.save!

      get :index, {format: :json, auth_token: user1_token}
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("challenges")
      json["challenges"].count.should eq(user1.challenges.count)
    end
    
    it "should return user1 own predictions" do
      user1.reset_authentication_token!
      user1.save
      user1_prediction.save!
      user2_prediction.save!

      get :index, {list: 'own', format: :json, auth_token: user1_token}
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("challenges")
      json["challenges"].count.should eq(user1.challenges.where(is_own: true).count)
    end
    
    it "should return user1 own unviewed predictions" do
      user1.reset_authentication_token!
      user1.save
      user1.challenges.where(is_own: true).update_all(seen: true)
      user1_prediction.save!
      user2_prediction.save!

      get :index, {list: 'own_unviewed', format: :json, auth_token: user1_token}
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("challenges")
      json["challenges"].count.should eq(user1.challenges.where(is_own: true, seen: false).count)
    end
    
    it "should return picks" do
      user1.reset_authentication_token!
      user1.save
      
      user1_prediction.save!
      user2_prediction.save!
      
      user1_challenge = user1.pick(user2_prediction, true)
      user1_challenge.save
      
      user2_challenge = user2.pick(user1_prediction, true)
      user2_challenge.save
      
      get :index, {list: 'picks', format: :json, auth_token: user1_token}
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("challenges")
      json["challenges"].count.should eq(user1.challenges.where(is_own: false).count)
    end

    it "should return picks unviewed" do
      user1.reset_authentication_token!
      user1.save
      
      user1_prediction.save!
      user2_prediction.save!
      
      user1_challenge = user1.pick(user2_prediction, true)
      user1_challenge.save
      
      user2_challenge = user2.pick(user1_prediction, true)
      user2_challenge.save
      
      user1.challenges.where(is_own: false).update_all(seen: false)
      
      get :index, {list: 'picks_unviewed', format: :json, auth_token: user1_token}
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("challenges")
      json["challenges"].count.should eq(user1.challenges.where(is_own: false, seen: false).count)
    end
    
    it "should return won picks" do
      user1.reset_authentication_token!
      user1.save
      
      user1_prediction.save!
      user2_prediction.save!
      
      user1_challenge = user1.pick(user2_prediction, true)
      user1_challenge.save
      
      user2_challenge = user2.pick(user1_prediction, true)
      user2_challenge.save
      
      user2_prediction.in_bs = true
      user2_prediction.close_as(true)
      
      get :index, {list: 'won_picks', format: :json, auth_token: user1_token}
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("challenges")
      json["challenges"].count.should eq(1)
    end
    
    it "should return won picks unviewed" do
      user1.reset_authentication_token!
      user1.save
      
      user1_prediction.save!
      user2_prediction.save!
      
      user1_challenge = user1.pick(user2_prediction, true)
      user1_challenge.save
      
      user2_challenge = user2.pick(user1_prediction, true)
      user2_challenge.save
      
      user2_prediction.in_bs = true
      user2_prediction.close_as(true)
      
      get :index, {list: 'won_picks_unviewed', format: :json, auth_token: user1_token}
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("challenges")
      json["challenges"].count.should eq(1)
    end
    
    it "should return lost picks" do
      user1.reset_authentication_token!
      user1.save
      
      user1_prediction.save!
      user2_prediction.save!
      
      user1_challenge = user1.pick(user2_prediction, true)
      user1_challenge.save
      
      user2_challenge = user2.pick(user1_prediction, true)
      user2_challenge.save
      
      user2_prediction.in_bs = true
      user2_prediction.close_as(true)
      
      get :index, {list: 'lost_picks', format: :json, auth_token: user1_token}
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("challenges")
      json["challenges"].count.should eq(0)
    end
    
    it "should return lost picks unviewed" do
      user1.reset_authentication_token!
      user1.save
      
      user1_prediction.save!
      user2_prediction.save!
      
      user1_challenge = user1.pick(user2_prediction, true)
      user1_challenge.save
      
      user2_challenge = user2.pick(user1_prediction, true)
      user2_challenge.save
      
      user2_prediction.in_bs = true
      user2_prediction.close_as(true)
      
      get :index, {list: 'lost_picks_unviewed', format: :json, auth_token: user1_token}
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("challenges")
      json["challenges"].count.should eq(0)
    end
    
    it "should return completed picks" do
      user1.reset_authentication_token!
      user1.save
      
      user1_prediction.save!
      user2_prediction.save!
      
      user1_challenge = user1.pick(user2_prediction, true)
      user1_challenge.save
      
      user2_challenge = user2.pick(user1_prediction, true)
      user2_challenge.save
      
      user2_prediction.in_bs = true
      user2_prediction.close_as(true)
      
      get :index, {list: 'completed', format: :json, auth_token: user1_token}
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("challenges")
      json["challenges"].count.should eq(1)
    end
    
    it "should return completed picks unviewed" do
      user1.reset_authentication_token!
      user1.save
      
      user1_prediction.save!
      user2_prediction.save!
      
      user1_challenge = user1.pick(user2_prediction, true)
      user1_challenge.save
      
      user2_challenge = user2.pick(user1_prediction, true)
      user2_challenge.save
      
      user2_prediction.in_bs = true
      user2_prediction.close_as(true)
      
      user1.challenges.where(is_own: false, is_finished: true).update_all(seen: true)
      
      get :index, {list: 'completed_unviewed', format: :json, auth_token: user1_token}
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("challenges")
      json["challenges"].count.should eq(0)
    end
    
    it "should return expired user1 challenges" do
      user1.reset_authentication_token!
      user1.save
      user1_prediction.save!
      
      user1_prediction.in_bs = true
      user1_prediction.expires_at = DateTime.now - 100.days
      user1_prediction.save!(validate: false)
      
      get :index, {list: 'expired', format: :json, auth_token: user1_token}
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("challenges")
      json["challenges"].count.should eq(1)
    end
    
    it "should return expired unviewed user1 challenges" do
      user1.reset_authentication_token!
      user1.save
      user1_prediction.save!
      
      user1_prediction.in_bs = true
      user1_prediction.expires_at = DateTime.now - 100.days
      user1_prediction.save!(validate: false)
      
      user1.challenges.update_all(seen: true)
      
      get :index, {list: 'expired_unviewed', format: :json, auth_token: user1_token}
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("challenges")
      json["challenges"].count.should eq(0)
    end
  end
  
  describe "GET show" do
    it "should be successful response" do
      user1.reset_authentication_token!
      user1.save
      user1_prediction.save!
      
      get :show, {id: user1.challenges.first.id, format: :json, auth_token: user1_token}
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("id")
      json.should include("agree")
      json.should include("user")
      json.should include("prediction")
    end
  end

  describe "POST set_seen" do
    it "should be successful response" do
      user1.reset_authentication_token!
      user1.save
      user1_prediction.save!
      
      get :set_seen, {ids: [user1.challenges.first.id], format: :json, auth_token: user1_token}
      response.status.should eq(204)
    end
  end
end
