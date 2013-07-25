require 'spec_helper'

describe Api::AppleDeviceTokensController do
  user = login_as_user(true)
  let(:valid_session) { {:auth_token => user.authentication_token} }
  
  describe "GET apple_device_tokens.json" do
    it "should be successful response" do
      get :index, {format: :json}, valid_session
      response.status.should eq(200)
    end
  end

  describe "POST apple_device_tokens.json" do
    it "should be successful response" do
      post :create, {format: :json, auth_token: user.authentication_token, apple_device_token: {token: "TOKEN"}}
      response.status.should eq(201)
    end
  end
end
