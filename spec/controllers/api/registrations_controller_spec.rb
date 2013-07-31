require 'spec_helper'

describe Api::RegistrationsController do  
  let(:user) {FactoryGirl.build(:user)}
  let(:valid_attributes) {{ username: user.username, email: user.email, password: user.password_confirmation}}
  let(:invalid_attributes) {{username:'aaaa', email:'bbbb', password:'xxxxx'}}
  
  describe "POST registration.json" do
    it "should sign up using registration.json" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      
      @user = FactoryGirl.build(:user)
      
      post :create, {:user => {
        :username   => @user.username,
        :email      => @user.email,
        :password   => @user.password_confirmation
      }}, :format => :json
      
      response.status.should eq(200)
      json = JSON.parse(response.body)
      
      json["success"].should eq(true)
      
      token = json["auth_token"]
      
      new_user = User.find_by(:authentication_token => token)
      new_user.should_not be_nil
      
      new_user.email.should eq(@user.email)
    end
    
    it "should not sign up with invalid attributes" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      
      post :create, {user: invalid_attributes}, format: :json
      response.status.should eq(400)
      
      json = JSON.parse(response.body)
      json["success"].should eq(false)
      json.should include("errors")
    end
  end
end
