require 'spec_helper'

describe Challenge do
  it 'is assigned 10 base points if it is your own prediction' do
    challenge = Challenge.new
    challenge.is_own = true
    expect(challenge.base_points).to eq(10)
  end

  it 'is assigned 5 base points if it is someone elses prediction' do
    challenge = Challenge.new
    challenge.is_own = false
    expect(challenge.base_points).to eq(5)
  end
end
