require 'spec_helper'

describe Api::AppleDeviceTokensController do
  user = login_as_user(true)
  let(:valid_session) { {:auth_token => user.authentication_token} }
  
  describe "GET apple_device_tokens.json" do
    it "should be successful response" do
      get :index, {format: :json}, valid_session
      json = JSON.parse(response.body)
      json.should include("apple_device_tokens")
      response.status.should eq(200)
    end
  end
  
  describe "GET apple_device_token/:id.json" do
    it "should be successful response" do
      token = FactoryGirl.create(:apple_device_token)
      token.user = user
      token.save
      
      get :show, {format: :json, id: token.id}, valid_session
      json = JSON.parse(response.body)
      json.should include("id")
      json.should include("token")
      json.should include("created_at")
      response.status.should eq(200)
    end
  end

  describe "POST apple_device_tokens.json" do
    it "should be successful response" do
      token = FactoryGirl.build(:apple_device_token)
      expect {
        post :create, {format: :json, auth_token: user.authentication_token, apple_device_token: {token: token.token}}
      }.to change(AppleDeviceToken, :count).by(1)
      
      response.status.should eq(201)
    end
  end
end
