require 'spec_helper'

describe Api::BadgesController do
  user = login_as_user(true)
  let(:valid_session) { {:auth_token => user.authentication_token} }
  
  describe "GET index.json" do
    it "should return list of topics" do      
      get :index, {format: :json}, valid_session
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("badges")
    end    
  end
  
  describe "GET badges/recent.json" do
    it "should return recent badges" do
      get :recent, {format: :json}, valid_session
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("badges")
    end
  end
end
