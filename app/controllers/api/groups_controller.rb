class Api::GroupsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_group, only: [:show, :update, :destroy, :leaderboard, :predictions, :memberships, :destroyAvatar]
  respond_to :json

  def index
    @groups = current_user.groups.alphabetical
    @groups = @groups.id_lt(param_id_lt)
    respond_with(@groups.offset(param_offset).limit(param_limit), each_serializer: GroupSerializer, root:false)
  end

  def predictions
    @predictions = Prediction.recent.latest.for_group(@group.id)
    respond_with(@predictions.offset(param_offset).limit(param_limit), each_serializer: PredictionFeedSerializerV2, root: false)      
  end


  def create
    @group = current_user.groups.create(group_params)
    if @group.avatar.blank?
      av = (1 + rand(5))
      p = Rails.root.join('app', 'assets', 'images', 'avatars', "groups_avatar_#{av}@2x.png")
      @group.avatar_from_path p          
      @group.save
    end    
    current_user.memberships.where(:group_id => @group.id).first.update(role: 'OWNER')
    respond_with(@group, :location => "#{api_groups_url}/#{@group.id}.json")
  end

  def destroyAvatar
    av = (1 + rand(5))
    p = Rails.root.join('app', 'assets', 'images', 'avatars', "groups_avatar_#{av}@2x.png")
    @group.avatar_from_path p          
    @group.save
    respond_with(@group, :location => "#{api_groups_url}/#{@group.id}.json")
  end

  def update
    respond_to do |format|
      authorize_action_for(@group)
      if @group.update(group_params)
        format.json { render json: @group, status: 200 }
      else
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end  

  def show
    respond_with(@group, :location => "#{api_groups_url}/#{@group.id}.json")
  end   

  def leaderboard
    if params[:board] == 'monthly'
      @leaders = Group.monthlyLeaderboard(@group)
    elsif params[:board] == 'alltime'
      @leaders = Group.allTimeLeaderboard(@group)
    else
      @leaders = Group.weeklyLeaderboard(@group)
    end    
    respond_with(@leaders, :location => "#{api_groups_url}/#{@group.id}/leaderboard.json", root: false)
  end

  def memberships
    @memberships = @group.memberships.joins(:user).order("users.username ASC")
    respond_with(@memberships, each_serializer: MembershipSerializer, root: false)
  end


  private
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.permit(:name, :description, :avatar)
    end    

end  