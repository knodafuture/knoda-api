require 'spec_helper'

describe Api::PasswordsController do
  describe "Change password using password.json" do
    it "should change password" do
      @request.env["devise.mapping"] = Devise.mappings[:user]

      @user = FactoryGirl.build :user
      @user.reset_authentication_token!
      @user.save!
      
      patch :update, {
        auth_token:       @user.authentication_token, 
        current_password: @user.password_confirmation, 
        new_password:     @user.password_confirmation.reverse}, :format => :json
      
      response.status.should eq(204);
    end
  end
end
