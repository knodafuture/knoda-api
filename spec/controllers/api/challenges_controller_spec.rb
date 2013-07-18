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
  end

end
