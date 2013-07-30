require 'spec_helper'

describe Api::TopicsController do
  user = login_as_user(true)
  let(:valid_session) { {:auth_token => user.authentication_token} }
  
  describe "GET index.json" do
    it "should return list of topics" do
      FactoryGirl.create(:topic)
      
      get :index, {format: :json}, valid_session
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("topics")
    end    
  end
  
end
