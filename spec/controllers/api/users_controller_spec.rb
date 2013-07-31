require 'spec_helper'

describe Api::UsersController do
  user = login_as_user(true)
  

  let(:valid_attributes) { {"user_id" => prediction.user_id, "body" => prediction.body, "expires_at" => prediction.expires_at,
                            "tag_list" => prediction.tag_list } }
  let(:valid_session) { {:auth_token => user.authentication_token} }

  describe "GET 'show'" do
    it "returns http success" do
      get :show, {id: user.id, format: :json}, valid_session
      response.should be_success
      json = JSON.parse(response.body)
      json.should include("id")
      json.should include("username")
      json.should include("email")
      json.should include("created_at")
      json.should include("avatar_image")
      json.should include("points")
      json.should include("total_predictions")
    end
  end
  
  describe "GET 'predictions'" do
    it "should return list of predictions" do
      prediction = FactoryGirl.build(:prediction)
      prediction.user_id = user.id
      prediction.save
      
      get :predictions, {:id => user.id, :format => :json}, valid_session
      json = JSON.parse(response.body)
      json.should include("predictions")
      json["predictions"].count.should eq(1)
    end
  end

end
