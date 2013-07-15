require 'spec_helper'

describe Api::UsersController do
  describe "GET user.json" do
    it "should return user information" do
      @user = FactoryGirl.build :user
      @user.password = 'password123'
      @user.password_confirmation = 'password123'
      @user.reset_authentication_token!
      @user.save!
      
      get :show, auth_token: @user.authentication_token, :format => :json
    
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json["username"].should eq(@user.username)
      json["email"].should eq(@user.email)
    end
  end
  
  #describe "PUT user.json" do
  #  it "should update avatar" do
  #    @user = FactoryGirl.build :user
  #    @user.password = 'password123'
  #    @user.password_confirmation = 'password123'
  #    @user.reset_authentication_token!
  #    @user.save!
  #    
  #    put :update, auth_token: @user.authentication_token, :user => {}, :format => :json
  #    
  #    response.status.should eq(200)
  #  end
  #end
end
