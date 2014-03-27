class Api::MembershipsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  before_action :set_membership, only: [:destroy]

  def create
    p = membership_params
    if p[:code]
      invitation = Invitation.where(:code => p[:code]).first
      if invitation != nil and invitation.group_id == p[:group_id]
        p.delete :code
        @membership = current_user.memberships.create(p)
        invitation.update(:accepted => true)
        respond_with(@membership, :location => "#{api_memberships_url}/#{@membership.id}.json")
        Group.rebuildLeaderboards(@membership.group)
      else
        head :forbidden
      end
    else
      head :forbidden
    end
  end

  def destroy
    authorize_action_for(@membership)
    @membership.destroy
    head :no_content
    Group.rebuildLeaderboards(@membership.group)
  end

  private
    def membership_params
      params.permit(:group_id, :code)
    end    
    def set_membership
      puts current_user.id
      @membership = Membership.find(params[:id])
    end        
end  