class Api::GroupsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_group, only: [:show, :update, :destroy, :leaderboard, :predictions]
  respond_to :json

  def index
    @groups = current_user.groups
    respond_with(@groups, each_serializer: GroupSerializer, root:false)
  end

  def predictions
    @predictions = @group.predictions
    respond_with(@predictions.offset(param_offset).limit(param_limit), each_serializer: PredictionFeedSerializerV2, root: false)      
  end


  def create
    @group = current_user.groups.create(group_params)
    current_user.memberships.where(:group_id => @group.id).first.update(role: 'OWNER')
    respond_with(@group, :location => "#{api_groups_url}/#{@group.id}.json")
  end

  def update
    respond_to do |format|
      authorize_action_for(@group)
      puts group_params
      if @group.update(group_params)
        respond_with(@group, :location => "#{api_groups_url}/#{@group.id}.json")
      else
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end  

  def show
    respond_with(@group, :location => "#{api_groups_url}/#{@group.id}.json")
  end   

  def leaderboard
    respond_with(@leaders = Group.weeklyLeaderboard(@group), :location => "#{api_groups_url}/#{@group.id}/leaderboard.json", root: false)
  end


  private
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.permit(:name, :description, :avatar)
    end    

end  