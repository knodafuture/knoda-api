require 'spec_helper'

describe Api::ChallengesController do

  user = login_as_user(true)

  let(:valid_session) { {:auth_token => user.authentication_token} }

  describe "GET challenges.json" do
    it "should be successful response" do
      prediction  = FactoryGirl.create :prediction
      challenge   = Challenge.create(:user_id => User.all.first.id, :prediction_id => prediction.id, :agree => 1)
      get :index, {:format => :json}, valid_session
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("challenges")
    end

    it "should be successful response with 'notifications' parameter" do
      prediction  = FactoryGirl.create :prediction
      challenge   = Challenge.create(:user_id => User.all.first.id, :prediction_id => prediction.id, :agree => 1)
      get :index, {:format => :json, :notifications => true}, valid_session
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("challenges")
    end
  end

  describe "GET show" do
    it "should be successful response" do
      prediction  = FactoryGirl.create :prediction
      challenge   = Challenge.create(:user_id => User.all.first.id, :prediction_id => prediction.id, :agree => 1)
      get :show, {:id => prediction.to_param, :format => :json}, valid_session
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
      prediction  = FactoryGirl.create :prediction
      challenge   = Challenge.create(:user_id => User.all.first.id, :prediction_id => prediction.id, :agree => 1)
      
      post :set_seen, {:ids => [challenge.id], :format => :json}, valid_session
      response.status.should eq(204)
    end
  end

end
