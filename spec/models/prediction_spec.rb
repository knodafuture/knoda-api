require 'spec_helper'

describe Prediction do
  it 'uses the contest name and stage when available' do
    contest = Contest.new
    contest.name = 'Contest 1'
    contest_stage = ContestStage.new
    contest_stage.name = 'Stage 1'
    prediction = Prediction.new
    prediction.contest = contest
    prediction.contest_stage = contest_stage
    expect(prediction.contest_name).to eq('Contest 1 - Stage 1')
  end

  it 'uses the contest name and when there is no stage' do
    contest = Contest.new
    contest.name = 'Contest 1'
    prediction = Prediction.new
    prediction.contest = contest
    expect(prediction.contest_name).to eq('Contest 1')
  end
end
