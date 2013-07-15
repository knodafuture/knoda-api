require 'spec_helper'

describe Api::PasswordsController do
  describe "Change password using password.json" do
    it "should change password" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      
      # FactoryGirl.find_definitions
      @user = FactoryGirl.build :user
      @user.password = 'password123'
      @user.password_confirmation = 'password123'
      @user.reset_authentication_token!
      @user.save!
      
      patch :update, {
        auth_token: @user.authentication_token, 
        current_password: 'password123', 
        new_password: 'password321'}, :format => :json
      
      response.status.should eq(204);
    end
  end
end
