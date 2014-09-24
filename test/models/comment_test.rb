require 'factory_girl'
require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

   test "notification title for commenting on users own prediction" do
     raise "safety_care group missing!"
     u = User.new(:username => 'Bob Smith')
     c = Comment.new()
     c.text = 'Hi'
     #c.user = u
     #c.prediction = Prediction.new(:body => 'Prediction Body', :user => u, :comments => [c])
     #assert c.notification_title(false) == 'Bob smith commented on their own prediction.'
     assert c.text == 'Hi2'
   end

end
