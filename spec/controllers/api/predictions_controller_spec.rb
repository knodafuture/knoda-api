require 'spec_helper'

describe Api::PredictionsController do
  let(:prediction) { FactoryGirl.build(:prediction) }

  let(:valid_attributes) { {"user_id" => prediction.user_id, "body" => prediction.body, "expires_at" => prediction.expires_at,
                            "tag_list" => prediction.tag_list } }
                     
  let(:invalid_tag_attributes) { {"body" => prediction.body, "expires_at" => prediction.expires_at,
                                  "tag_list" => ["invalid tag"]}}     
                                    
  let(:valid_update_attributes) { { "expires_at" => prediction.expires_at + 10.days }}
  let(:invalid_update_attributes) { { "expires_at" => DateTime.now - 10.days }}
  
  
  let(:topic) {FactoryGirl.create(:topic)}
  let(:user1) {FactoryGirl.create(:user)}
  let(:user2) {FactoryGirl.create(:user)}
  let(:user1_prediction) {user1.predictions.build(body: "body1", expires_at: DateTime.now + 10.days, tag_list: [topic.name])}
  let(:user2_prediction) {user2.predictions.build(body: "body2", expires_at: DateTime.now + 10.days, tag_list: [topic.name])}
  let(:user1_token) {user1.authentication_token}
  let(:user2_token) {user2.authentication_token}
  
  describe "GET index.json" do
    describe "get current user predictions" do
      it "should return one prediction" do
        user1.reset_authentication_token!
        user1.save
        
        user1_prediction.save
        user2_prediction.save
        
        get :index, {format: :json, auth_token: user1_token}
        response.status.should eq(200)
        json = JSON.parse(response.body)
        json.should include("predictions")
        json["predictions"].count.should eq(1)
      end
    end
    
    describe "get recent predictions tagged with given topic" do
      it "should return predictions tagged with given topic" do
        user1.reset_authentication_token!
        user1.save
        
        user1_prediction.save
        user2_prediction.save
        
        get :index, {format: :json, auth_token: user1_token, tag: topic.name}
        response.status.should eq(200)
        json = JSON.parse(response.body)
        json.should include("predictions")
        json["predictions"].count.should eq(2)
      end
    end
    
    describe "get recent all recent predictions" do
      it "should return all recent predictions" do
        user1.reset_authentication_token!
        user1.save
        
        user2_prediction.save
        
        get :index, {format: :json, auth_token: user1_token, recent: 1}
        response.status.should eq(200)
        json = JSON.parse(response.body)
        json.should include("predictions")
        json["predictions"].count.should eq(1)
      end
    end
  end
  
  describe "GET /id.json" do
    describe "get prediction details" do
      it "should return details for my prediction" do
        user1.reset_authentication_token!
        user1.save
        
        user1_prediction.save
        
        get :show, {format: :json, id: user1_prediction.id, auth_token: user1_token}
        response.status.should eq(200)
        json = JSON.parse(response.body)
        json.should include("id")
        json.should include("outcome")
        json.should include("expires_at")
        json.should include("created_at")
        json.should include("agreed_count")
        json.should include("disagreed_count")
        json.should include("market_size")
        json.should include("prediction_market")
        json.should include("user_id")
        json.should include("username")
        json.should include("user_avatar")
        json.should include("expired")
        json.should include("settled")
        json.should include("my_challenge")       
        json.should include("my_points")
      end
    end
  end
  
  describe "GET history for prediction" do
    describe "get history agreed" do
      it "should return history agreed" do
        user1.reset_authentication_token!
        user1.save

        user1_prediction.save!
        user2_prediction.save!

        user1_challenge = user1.pick(user2_prediction, true)
        user1_challenge.save

        user2_challenge = user2.pick(user1_prediction, true)
        user2_challenge.save
        
        get :history_agreed, {format: :json, id: user1_prediction.id, auth_token: user1_token}
        response.status.should eq(200)
        json = JSON.parse(response.body)
        json.should include("challenges")
        json["challenges"].count.should eq(1)
      end
    end
    
    describe "get history disagreed" do
      it "should return history disagreed" do
        user1.reset_authentication_token!
        user1.save

        user1_prediction.save!
        user2_prediction.save!

        user1_challenge = user1.pick(user2_prediction, true)
        user1_challenge.save

        user2_challenge = user2.pick(user1_prediction, false)
        user2_challenge.save
        
        get :history_disagreed, {format: :json, id: user1_prediction.id, auth_token: user1_token}
        response.status.should eq(200)
        json = JSON.parse(response.body)
        json.should include("challenges")
        json["challenges"].count.should eq(1)
      end
    end 
  end
  
  describe "get prediction challenge" do
    describe "when i picked prediction" do
      it "should return challenge" do
        user1.reset_authentication_token!
        user1.save

        user1_prediction.save!
        user2_prediction.save!

        user1_challenge = user1.pick(user2_prediction, true)
        user1_challenge.save
        
        get :challenge, {format: :json, id: user2_prediction.id, auth_token: user1_token}
        response.status.should eq(200)
        json = JSON.parse(response.body)
        json["id"].should eq(user1.challenges.where(is_own:false).first.id)
      end
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "should create a prediction" do
        user1.reset_authentication_token!
        user1.save
        
        expect {
          post :create, {:prediction => valid_attributes, :format => :json, auth_token: user1_token}
        }.to change(Prediction, :count).by(1)

      end

      it "should be successful response" do
        user1.reset_authentication_token!
        user1.save
        
        post :create, {:prediction => valid_attributes, :format => :json, auth_token: user1_token}
        response.status.should eq(201)
      end
    end

    describe "with invalid params" do
      it "should not create a prediction" do
        user1.reset_authentication_token!
        user1.save
        
        post :create, {:prediction => { "invalid key" => "invalid value" }, :format => :json, auth_token: user1_token}
        response.status.should eq(422)
      end
      
      it "with invalid tag should not created a prediction" do
        user1.reset_authentication_token!
        user1.save
        
        post :create, {:prediction => invalid_tag_attributes, :format => :json, auth_token: user1_token}
        response.status.should eq(422)
      end
    end
  end

  describe "PATCH update" do
    describe "as owner of prediction" do
      it "should update expires_at" do
        user1.reset_authentication_token!
        user1.save

        user1_prediction.save!
        user2_prediction.save!
        
        patch :update, {id: user1_prediction.id, format: :json, auth_token: user1_token, prediction: {expires_at: DateTime.now + 10.days}}
        response.status.should eq(204)
      end
      
      it "should not update expires_at" do
        user1.reset_authentication_token!
        user1.save

        user1_prediction.save!
        user2_prediction.save!
        
        patch :update, {id: user1_prediction.id, format: :json, auth_token: user1_token, prediction: {expires_at: DateTime.now - 10.days}}
        response.status.should eq(422)
      end
    end
    
    describe "as not owner of prediction" do
      it "should return 403" do
        user1.reset_authentication_token!
        user1.save

        user1_prediction.save!
        user2_prediction.save!
        
        patch :update, {id: user2_prediction.id, format: :json, auth_token: user1_token, prediction: {expires_at: DateTime.now + 10.days}}
        response.status.should eq(403)
      end
    end
  end

  describe "POST agree" do
    describe "as prediction owner" do
      it "should return 403" do
        user1.reset_authentication_token!
        user1.save

        user1_prediction.save!
        
        post :agree, {id: user1_prediction.id, format: :json, auth_token: user1_token}
        response.status.should eq(403)
      end
    end
    
    describe "as not prediction owner" do
      
      describe "with active prediction" do
        it "should return success" do
          user1.reset_authentication_token!
          user1.save

          user2_prediction.save!

          post :agree, {id: user2_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(201)
          user1.challenges.where(is_own: false, agree: true).count.should eq(1)
          
          post :agree, {id: user2_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(422)
        end
      end
      
      describe "with expired prediction" do
        it "should return 403" do
          user1.reset_authentication_token!
          user1.save

          user2_prediction.save!
          user2_prediction.expires_at = DateTime.now - 10.days
          user2_prediction.save!(validate: false)
          
          user2_prediction.reload.is_expired?.should eq(true)
          post :agree, {id: user2_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(403)          
        end
      end
      
      describe "with settled prediction" do
        it "should return 403" do
          user1.reset_authentication_token!
          user1.save

          user2_prediction.save!
          user2_prediction.in_bs = true
          user2_prediction.close_as(true)
          
          user2_prediction.reload.is_closed?.should eq(true)
          post :agree, {id: user2_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(403)
        end
      end
    end
  end

  describe "POST disagree" do
    describe "as prediction owner" do
      it "should return 403" do
        user1.reset_authentication_token!
        user1.save

        user1_prediction.save!
        
        post :disagree, {id: user1_prediction.id, format: :json, auth_token: user1_token}
        response.status.should eq(403)
      end
    end
    
    describe "as not prediction owner" do
      
      describe "with active prediction" do
        it "should return success" do
          user1.reset_authentication_token!
          user1.save

          user2_prediction.save!

          post :disagree, {id: user2_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(201)
          user1.challenges.where(is_own: false, agree: false).count.should eq(1)
          
          post :disagree, {id: user2_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(422)
        end
      end
      
      describe "with expired prediction" do
        it "should return 403" do
          user1.reset_authentication_token!
          user1.save

          user2_prediction.save!
          user2_prediction.expires_at = DateTime.now - 10.days
          user2_prediction.save!(validate: false)
          
          user2_prediction.reload.is_expired?.should eq(true)
          post :disagree, {id: user2_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(403)          
        end
      end
      
      describe "with settled prediction" do
        it "should return 403" do
          user1.reset_authentication_token!
          user1.save

          user2_prediction.save!
          user2_prediction.in_bs = true
          user2_prediction.close_as(true)
          
          user2_prediction.reload.is_closed?.should eq(true)
          post :disagree, {id: user2_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(403)
        end
      end
    end
  end
  
  describe "POST realize" do
    describe "as prediction owner" do
      
      describe "with active prediction" do
        it "should return 403" do
          user1.reset_authentication_token!
          user1.save
          
          user1_prediction.save!
          
          post :realize, {id: user1_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(403)
        end
      end
      
      describe "with expired and settled prediction" do
        it "should return 403" do
          user1.reset_authentication_token!
          user1.save
          
          user1_prediction.save!
          user1_prediction.expires_at = DateTime.now - 10.days
          user1_prediction.is_closed = true
          user1_prediction.outcome = true
          user1_prediction.save!(validate: false)
          
          post :realize, {id: user1_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(403)
        end
      end
      
      describe "with expired and not settled prediction" do
        it "should return success" do
          user1.reset_authentication_token!
          user1.save
          
          user1_prediction.save!
          user1_prediction.expires_at = DateTime.now - 10.days
          user1_prediction.save!(validate: false)
          user1_prediction.reload.is_closed?.should eq(false)
          user1_prediction.reload.outcome.should eq(nil)
          
          post :realize, {id: user1_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(201)
          
          user1_prediction.reload.is_closed?.should eq(true)
          user1_prediction.reload.outcome.should eq(true)
          
          user1.challenges.where(is_own: true, is_right: true).count.should eq(1)
        end
      end
    end
    
    describe "as not prediction owner" do
      
      describe "with active not picked prediction" do
        it "should return 403" do
          user1.reset_authentication_token!
          user1.save
          
          user2_prediction.save!
          
          post :realize, {id: user2_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(403)
        end
      end
      
      describe "with active and picked prediction" do
        it "should return 403" do
          user1.reset_authentication_token!
          user1.save
          
          user2_prediction.save!
          user1_challenge = user1.pick(user2_prediction, true)
          user1_challenge.save
          
          post :realize, {id: user2_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(403)
        end
      end
      
      describe "with expired and settled prediction" do
        it "should return 403" do
          user1.reset_authentication_token!
          user1.save
          
          user2_prediction.save!
          user2_prediction.expires_at = DateTime.now - 10.days
          user2_prediction.is_closed = true
          user2_prediction.outcome = true
          user2_prediction.save!(validate: false)
          
          post :realize, {id: user2_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(403)
        end
      end
      
      describe "with expired and not settled prediction" do
        it "should return success" do
          user1.reset_authentication_token!
          user1.save
          
          user2_prediction.save!
          user2_prediction.expires_at = DateTime.now - 1.days
          user2_prediction.save!(validate: false)
          user2_prediction.reload.is_closed?.should eq(false)
          user2_prediction.reload.outcome.should eq(nil)
          
          post :realize, {id: user2_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(403)
        end
      end
      
      describe "with expired more than 3 days and not settled prediction" do
        it "should return success" do
          user1.reset_authentication_token!
          user1.save
          
          user2_prediction.save!
          
          user1_challenge = user1.pick(user2_prediction, true)
          user1_challenge.save!
          
          user2_prediction.expires_at = DateTime.now - 3.days
          user2_prediction.save!(validate: false)
          user2_prediction.reload.is_closed?.should eq(false)
          user2_prediction.reload.outcome.should eq(nil)
          
          post :realize, {id: user2_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(201)
        end
      end
    end
  end



  describe "POST unrealize" do
    describe "as prediction owner" do
      
      describe "with active prediction" do
        it "should return 403" do
          user1.reset_authentication_token!
          user1.save
          
          user1_prediction.save!
          
          post :unrealize, {id: user1_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(403)
        end
      end
      
      describe "with expired and settled prediction" do
        it "should return 403" do
          user1.reset_authentication_token!
          user1.save
          
          user1_prediction.save!
          user1_prediction.expires_at = DateTime.now - 10.days
          user1_prediction.is_closed = true
          user1_prediction.outcome = true
          user1_prediction.save!(validate: false)
          
          post :unrealize, {id: user1_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(403)
        end
      end
      
      describe "with expired and not settled prediction" do
        it "should return success" do
          user1.reset_authentication_token!
          user1.save
          
          user1_prediction.save!
          user1_prediction.expires_at = DateTime.now - 10.days
          user1_prediction.save!(validate: false)
          user1_prediction.reload.is_closed?.should eq(false)
          user1_prediction.reload.outcome.should eq(nil)
          
          post :unrealize, {id: user1_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(201)
          
          user1_prediction.reload.is_closed?.should eq(true)
          user1_prediction.reload.outcome.should eq(false)
          
          user1.challenges.where(is_own: true, is_right: false).count.should eq(1)
        end
      end
    end
    
    describe "as not prediction owner" do
      
      describe "with active not picked prediction" do
        it "should return 403" do
          user1.reset_authentication_token!
          user1.save
          
          user2_prediction.save!
          
          post :unrealize, {id: user2_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(403)
        end
      end
      
      describe "with active and picked prediction" do
        it "should return 403" do
          user1.reset_authentication_token!
          user1.save
          
          user2_prediction.save!
          user1_challenge = user1.pick(user2_prediction, true)
          user1_challenge.save
          
          post :unrealize, {id: user2_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(403)
        end
      end
      
      describe "with expired and settled prediction" do
        it "should return 403" do
          user1.reset_authentication_token!
          user1.save
          
          user2_prediction.save!
          user2_prediction.expires_at = DateTime.now - 10.days
          user2_prediction.is_closed = true
          user2_prediction.outcome = true
          user2_prediction.save!(validate: false)
          
          post :unrealize, {id: user2_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(403)
        end
      end
      
      describe "with expired and not settled prediction" do
        it "should return success" do
          user1.reset_authentication_token!
          user1.save
          
          user2_prediction.save!
          user2_prediction.expires_at = DateTime.now - 1.days
          user2_prediction.save!(validate: false)
          user2_prediction.reload.is_closed?.should eq(false)
          user2_prediction.reload.outcome.should eq(nil)
          
          post :unrealize, {id: user2_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(403)
        end
      end
      
      describe "with expired more than 3 days and not settled prediction" do
        it "should return success" do
          user1.reset_authentication_token!
          user1.save
          
          user2_prediction.save!
          
          user1_challenge = user1.pick(user2_prediction, true)
          user1_challenge.save!
          
          user2_prediction.expires_at = DateTime.now - 3.days
          user2_prediction.save!(validate: false)
          user2_prediction.reload.is_closed?.should eq(false)
          user2_prediction.reload.outcome.should eq(nil)
          
          post :unrealize, {id: user2_prediction.id, format: :json, auth_token: user1_token}
          response.status.should eq(201)
        end
      end
    end
  end



end