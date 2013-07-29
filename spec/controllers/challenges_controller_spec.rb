require 'spec_helper'

describe ChallengesController do

  user = login_as_user

  let(:challenge) { FactoryGirl.create(:challenge) }

  let(:valid_attributes) { {"user_id" => challenge.user_id, "prediction_id" => challenge.prediction_id} }

  let(:valid_session) { {:auth_token => user.authentication_token} }
  


  describe "GET index" do
    it "returns http success" do
      pending "because of no CMS"
      challenge = user.challenges.create(valid_attributes)
      get :index, {}, valid_session
      response.should be_success
    end
  end

  describe "GET show" do
    it "returns http success" do
      pending "because of no CMS"
      challenge = user.challenges.create(valid_attributes)
      get :show, {:id => challenge.to_param}, valid_session
      response.should be_success
    end
  end

end
