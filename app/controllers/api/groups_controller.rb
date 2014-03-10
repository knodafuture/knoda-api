class Api::GroupsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_comment, only: [:show, :update, :destroy]
  respond_to :json

  def index
    @groups = current_user.groups
    respond_with(@groups, each_serializer: GroupSerializer, root:false)
  end

  def create
    @group = current_user.groups.create(group_params)
    current_user.memberships.where(:group_id => @group.id).first.update(role: 'OWNER')
    respond_with(@group, :location => "#{api_groups_url}/#{@group.id}.json")
  end

  def show
    respond_with(@group, :location => "#{api_groups_url}/#{@group.id}.json")
  end   


  private
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.permit(:name, :description, :avatar)
    end    

end  