require 'spec_helper'

describe Api::SessionsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:valid_attributes) { {login: user.username, password: user.password_confirmation}}
  let(:invalid_attributes) { {login: "invalid"} }
  
  describe "POST session.json" do
    
    it "should login using session.json" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      
      post :create, {user: valid_attributes}, format: :json

      response.status.should eq(200)
      json = JSON.parse(response.body)
      json["email"].should eq(user.email);
      
      @token = json["auth_token"]
      
      user = User.find_by(:authentication_token => @token)
      user.should_not be_nil
      
      user.email.should eq(user.email)
    end
    
    it "should not login using invalid crendentials" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      
      post :create, {user: invalid_attributes}, format: :json
      response.status.should eq(403)      
    end
  end


  describe "DELETE session.json" do
    it "should destroy session" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      
      user.reset_authentication_token!
      user.save!
      
      @token = user.authentication_token
      
      delete :destroy, {auth_token: @token}, :format => :json
      user = User.find_by(:authentication_token => @token)
      user.should be_nil
    end
  end
end
