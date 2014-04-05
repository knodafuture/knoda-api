class Api::MembershipsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  before_action :set_membership, only: [:destroy]
  after_action :rebuild_leaderboard, only: [:destroy, :create]

  def create
    p = membership_params
    if p[:code]
      code = p[:code]
      invitation = Invitation.where(:code => code, :group_id => p[:group_id]).first
      if invitation != nil and not invitation.accepted
        p.delete :code
        @membership = current_user.memberships.create(p)
        invitation.update(:accepted => true)
        respond_with(@membership, :location => "#{api_memberships_url}/#{@membership.id}.json")
        Activity.where(:invitation_code => code, :activity_type => 'INVITATION').delete_all
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
  end

  private
    def membership_params
      params.permit(:group_id, :code)
    end    
    def set_membership
      puts current_user.id
      @membership = Membership.find(params[:id])
    end        
    def rebuild_leaderboard
      LeaderboardRebuild.new.async.perform(@membership.group_id)
    end    
end  