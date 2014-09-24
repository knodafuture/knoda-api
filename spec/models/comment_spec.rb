require 'spec_helper'

describe Comment do
  it 'formats notification_title correctly when there is only 1 comment' do
    adam = User.create!(:username => 'Adam', :password => 'poop123')
    prediction = Prediction.create!(:user => adam, :body => 'Test', :tags => ['OTHER'], :expires_at => (DateTime.now + 10.minutes))
    comment = Comment.create!(:user => adam, :prediction => prediction, :text => 'My Comment')
    expect(comment.notification_title(true)).to eq('Adam commented on a prediction by you.')
  end

  it 'formats notification_title correctly when there are 2 commenting users' do
    adam = User.create!(:username => 'Adam', :password => 'poop123')
    bob = User.create!(:username => 'Bob', :email => 'bob@test.com', :password => 'poop123')
    prediction = Prediction.create!(:user => adam, :body => 'Test', :tags => ['OTHER'], :expires_at => (DateTime.now + 10.minutes))
    comment1 = Comment.create!(:user => adam, :prediction => prediction, :text => "Adam's Comment")
    comment2 = Comment.create!(:user => bob, :prediction => prediction, :text => "Bob's Comment")
    expect(comment2.notification_title(false)).to eq("Bob commented on a prediction by Adam.")
  end

  it 'formats notification_title correctly when there are 3 commenting users' do
    adam = User.create!(:username => 'Adam', :password => 'poop123')
    bob = User.create!(:username => 'Bob', :email => 'bob@test.com', :password => 'poop123')
    carol = User.create!(:username => 'Carol', :email => 'carol@test.com', :password => 'poop123')
    prediction = Prediction.create!(:user => adam, :body => 'Test', :tags => ['OTHER'], :expires_at => (DateTime.now + 10.minutes))
    comment1 = Comment.create!(:user => adam, :prediction => prediction, :text => "Adam's Comment")
    comment2 = Comment.create!(:user => bob, :prediction => prediction, :text => "Bob's Comment")
    comment3 = Comment.create!(:user => carol, :prediction => prediction, :text => "Carol's Comment")
    expect(comment3.notification_title(false)).to eq("Carol commented on a prediction by Adam.")
  end

end
