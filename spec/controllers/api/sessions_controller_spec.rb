require 'spec_helper'

describe Api::SessionsController do
  describe "POST session.json" do
    
    it "should login using session.json" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
          
      @user = FactoryGirl.create :user
      
      post :create, {:user => {
        :login      => @user.username,
        :password   => "password"
      }}, :format => :json
      
      Rails.logger.info "BODY"
      Rails.logger.info response.body
      
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json["email"].should eq(@user.email);
      
      @token = json["auth_token"]
      
      user = User.find_by(:authentication_token => @token)
      user.should_not be_nil
      
      user.email.should eq(@user.email)
    end
  end


  describe "DELETE session.json" do
    it "should destroy session" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      
      # FactoryGirl.find_definitions
      @user = FactoryGirl.create :user
      @user.reset_authentication_token!
      @user.save!
      
      @token = @user.authentication_token
      
      delete :destroy, {auth_token: @token}, :format => :json
      user = User.find_by(:authentication_token => @token)
      user.should be_nil
    end
  end
end
