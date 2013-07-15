require 'spec_helper'

describe Api::RegistrationsController do  
  describe "POST registration.json" do
    it "should sign up using registration.json" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      
      @user = FactoryGirl.build :user
      
      Rails.logger.info "USER"
      Rails.logger.info @user.username
      Rails.logger.info @user.password
      Rails.logger.info @user.email
      
      post :create, {:user => {
        :username   => @user.username,
        :email      => @user.email,
        :password   => @user.password
      }}, :format => :json
      
      response.status.should eq(200)
      json = JSON.parse(response.body)
      
      json["success"].should eq(true)
      
      token = json["auth_token"]
      
      user = User.find_by(:authentication_token => token)
      user.should_not be_nil
      
      user.email.should eq(@user.email)
    end
  end
end
