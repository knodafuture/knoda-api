require 'spec_helper'

describe Api::PredictionsController do

  user = login_as_user(true)

  let(:prediction) { FactoryGirl.build(:prediction) }

  let(:valid_attributes) { {"user_id" => prediction.user_id, "body" => prediction.body, "expires_at" => prediction.expires_at,
                            "outcome" => prediction.outcome, "tag_list" => prediction.tag_list} }

  let(:valid_session) { {:auth_token => user.authentication_token} }

  let(:user2) { FactoryGirl.create(:user) }

  describe "GET predictions.json" do
    it "should be successful response" do
      prediction = user.predictions.create(valid_attributes)
      get :index, {:format => :json}, valid_session
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("predictions")
    end

    it "should be successful response with tag parameter" do
      prediction = user.predictions.create(valid_attributes)
      get :index, {:format => :json, :tag => prediction.tag_list}, valid_session
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("predictions")
    end

    it "should be successful response with 'new' parameter" do
      prediction = user.predictions.create(valid_attributes)
      get :index, {:format => :json, :recent => true}, valid_session
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("predictions")
    end

    it "should be successful response with 'recent' parameter" do
      prediction = user.predictions.create(valid_attributes)
      get :index, {:format => :json, :recent => true}, valid_session
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("predictions")
    end

    it "should be successful response with 'recent' and 'user_id' parameters" do
      prediction = user.predictions.create(valid_attributes)
      get :index, {:format => :json, :recent => true, :user_id => User.first.id}, valid_session
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("predictions")
    end

    it "should be successful response with 'expired' parameter" do
      prediction = user.predictions.create(valid_attributes)
      get :index, {:format => :json, :expired => true, :user_id => User.first.id}, valid_session
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("predictions")
    end
  end

  describe "GET show" do
    it "should be successful response" do
      prediction = user.predictions.create(valid_attributes)
      get :show, {:id => prediction.to_param, :format => :json}, valid_session
      response.status.should eq(200)
      json = JSON.parse(response.body)
      json.should include("id")
      json.should include("user_id")
      json.should include("body")
      json.should include("outcome")
      json.should include("expires_at")
      json.should include("tags")
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "should create a prediction" do
        expect {
          post :create, {:prediction => valid_attributes, :format => :json}, valid_session
        }.to change(Prediction, :count).by(1)

      end

      it "should be successful response" do
        prediction = user.predictions.create(valid_attributes)
        post :create, {:prediction => valid_attributes, :format => :json}, valid_session
        response.status.should eq(201)
      end
    end

    describe "with invalid params" do
      it "should not create a prediction" do
        Prediction.any_instance.stub(:save).and_return(false)
        post :create, {:prediction => { "user_id" => "invalid value" }, :format => :json}, valid_session
        response.status.should eq(422)
      end
    end
  end

  describe "POST agree" do
    describe "as author of prediction" do
      it "should not create a challenge" do
        prediction = user.predictions.create(valid_attributes)
        put :agree, {:id => prediction.to_param, :format => :json}, valid_session
        response.status.should eq(403)
      end
    end

    describe "as not author of prediction" do
      it "should create a challenge" do
        prediction = user.predictions.create(valid_attributes)
        prediction.user_id = user2.id
        prediction.save!

        put :agree, {:id => prediction.to_param, :format => :json}, valid_session
        response.status.should eq(204)
      end
    end
  end

  describe "POST disagree" do
    describe "as author of prediction" do
      it "should not create a challenge" do
        prediction = user.predictions.create(valid_attributes)
        put :disagree, {:id => prediction.to_param, :format => :json}, valid_session
        response.status.should eq(403)
      end
    end

    describe "as not author of prediction" do
      it "should create a challenge" do
        prediction = user.predictions.create(valid_attributes)
        prediction.user_id = user2.id
        prediction.save!

        put :disagree, {:id => prediction.to_param, :format => :json}, valid_session
        response.status.should eq(204)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "should update a prediction" do
        pending
        prediction = user.predictions.create(valid_attributes)
        put :update, {:id => prediction.to_param, :prediction => { "user_id" => "1" }, :format => :json}, valid_session
        response.status.should eq(204)
      end
    end

    describe "with invalid params" do
      it "should not update a prediction" do
        pending
        prediction = user.predictions.create(valid_attributes)
        Prediction.any_instance.should_receive(:update).with({ "user_id" => "invalid value" })
        put :update, {:id => prediction.to_param, :prediction => { "user_id" => "invalid value" }, :format => :json}, valid_session
        response.status.should eq(422)
      end
    end
  end

  describe "DELETE destroy" do
    it "should destroy a prediction" do
      prediction = user.predictions.create(valid_attributes)
      expect {
        delete :destroy, {:id => prediction.to_param, :format => :json}, valid_session
      }.to change(Prediction, :count).by(-1)
      response.status.should eq(204)
    end
  end
end
