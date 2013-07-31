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
    
    it "should not return data with invalid auth_token" do
      @user = FactoryGirl.build :user
      @user.reset_authentication_token!
      @user.save
      
      get :show, auth_token: 'invalid_token', :format => :json
      response.status.should eq(403)
    end
    
    it "should return streak positive streak" do
      @user = FactoryGirl.build :user
      @user.reset_authentication_token!
      @user.streak = rand(1..1000)
      @user.save!
      
      get :show, auth_token: @user.authentication_token, :format => :json
      response.status.should eq(200)
      
      json = JSON.parse(response.body)
      json['streak'].should eq("W"+@user.streak.to_s)
    end
    
    it "should return streak negative streak" do
      @user = FactoryGirl.build :user
      @user.reset_authentication_token!
      @user.streak = -rand(1..1000)
      @user.save!
      
      get :show, auth_token: @user.authentication_token, :format => :json
      response.status.should eq(200)
      
      json = JSON.parse(response.body)
      json['streak'].should eq("L"+@user.streak.abs.to_s)
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
    
    it "should not update with invalid parameters" do
      @user = FactoryGirl.build :user
      @user.reset_authentication_token!
      @user.save!
      
      put :update, auth_token: @user.authentication_token, :user => {:username => ''}, :format => :json
      
      response.status.should eq(422)
    end
    
    it "should change email" do
      @user = FactoryGirl.build :user
      @user.reset_authentication_token!
      @user.save!
      
      put :update, auth_token: @user.authentication_token, :user => {:email => 'new_'+@user.email}, :format => :json
      
      response.status.should eq(204)
    end
    
    it "should change username" do
      @user = FactoryGirl.build :user
      @user.reset_authentication_token!
      @user.save!
      
      put :update, auth_token: @user.authentication_token, :user => {:username => @user.username+'new'}, :format => :json
      
      response.status.should eq(204)
    end
    
    
    
    it "should update avatar" do
      pending "updating avatar"
    end
  end
end
