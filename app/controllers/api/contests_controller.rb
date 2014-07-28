class Api::ContestsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  before_action :set_contest, except: [:index]

  def index
    if params[:list]
      if params[:list].downcase == 'entered'
        @contests = Contest.entered_by_user(current_user.id)
      elsif params[:list].downcase == 'explore'
        @contests = Contest.not_entered_by_user(current_user.id)
      end
    else
      @contests = Contest.all
    end
    respond_with(@contests, each_serializer: ContestSerializer, root: false)
  end

  def leaderboard
    if params[:stage]
      @leaders = Contest.stage_leaderboard(ContestStage.find(params[:stage]))
    else
      @leaders = Contest.leaderboard(@contest)
    end
    respond_with(@leaders, :location => "#{api_contests_url}/#{@contest.id}/leaderboard.json", root: false)
  end

  def predictions
    if params[:list] and params[:list].downcase == 'expired'
      @predictions = Prediction.where("predictions.expires_at < now()").for_contest(@contest.id)
    else
      @predictions = Prediction.recent.latest.for_contest(@contest.id)
    end
    respond_with(@predictions, each_serializer: PredictionFeedSerializerV2, root:false)
  end

  private
  def set_contest
    @contest = Contest.find(params[:id])
  end
end
