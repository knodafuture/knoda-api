require 'spec_helper'

describe Following do
  it 'is invalid if the leader and follower are the same' do
    user = User.new(:id => 1, :username => "Bob", :email => 'bob@test.com')
    following = Following.new(:user_id => 1, :leader_id => 1)
    following.cannot_follow_yourself
    expect(following.errors.size).to eq(1)
  end
end
