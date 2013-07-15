require 'spec_helper'

describe Api::SessionsController do
  describe "POST session.json" do
    
    it "should login using session.json" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @request.env['CONTENT_TYPE'] = 'application/json'
      @request.env['ACCEPT'] = 'application/json'
          
      @user = FactoryGirl.build :user
      @user.password              = "hello123456"
      @user.password_confirmation = "hello123456"
      @user.save!
      
      Rails.logger.info "USER"
      Rails.logger.info @user.username
      Rails.logger.info @user.password
      Rails.logger.info @user.email
      
      post :create, {:user => {
        :login   => @user.username,
        :password   => "hello123456"
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
      @request.env['CONTENT_TYPE'] = 'application/json'
      @request.env['ACCEPT'] = 'application/json'
      
      # FactoryGirl.find_definitions
      @user = FactoryGirl.build :user
      @user.password = 'password123'
      @user.password_confirmation = 'password123'
      @user.reset_authentication_token!
      @user.save!
      
      @token = @user.authentication_token
      
      delete :destroy, {auth_token: @token}, :format => :json
      user = User.find_by(:authentication_token => @token)
      user.should be_nil
    end
  end
end
