require 'spec_helper'

describe Api::ProfilesController do
  describe "GET profile.json" do
    it "should return user information" do
      @user = FactoryGirl.build :user
      @user.reset_authentication_token!
      @user.save!
      
      get :show, auth_token: @user.authentication_token, :format => :json
    
      response.status.should eq(200)
      
      json = JSON.parse(response.body)
      json["username"].should eq(@user.username)
      json["email"].should eq(@user.email)
      
      json.should include("id")
      json.should include("created_at")
      json.should include("avatar_image")
      json.should include("notifications")
      json.should include("points")
      json.should include("won")
      json.should include("lost")
      json.should include("winning_percentage")
      json.should include("streak")
      json.should include("alerts")
      json.should include("badges")
      
      json["badges"].should eq(@user.badges.count)      
    end
  end
  
  describe "PUT profile.json" do    
    it "should update notifications" do      
      @user = FactoryGirl.build :user
      @user.reset_authentication_token!
      @user.save!
      
      put :update, auth_token: @user.authentication_token, :user => {:notifications => false}, :format => :json
      
      response.status.should eq(204)
      
      @user = User.find(@user.id)
      @user.notifications.should be(false)
    end
    
    it "should update avatar" do
      pending "updating avatar"
    end
  end
end
