require 'spec_helper'

describe Api::PasswordsController do
  let(:user) { FactoryGirl.build(:user) }
  
  describe "Forgot password" do
    it "should send forgot password email for existing user" do
      user.save
      
      post :create, {login: user.email, format: :json}
      response.status.should eq(204)
    end
    
    it "should return 404 for bad email" do
      post :create, {login: "bad_email@example.com", format: :json}
      response.status.should eq(404)
    end
  end
  
  
  describe "Change password using password.json" do    
    it "should change password" do
      user.reset_authentication_token!
      user.save
      
      patch :update, {
        auth_token:       user.authentication_token, 
        current_password: user.password_confirmation, 
        new_password:     user.password_confirmation.reverse}, :format => :json
      
      response.status.should eq(204);
    end
  end
end
