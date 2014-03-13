class Api::MembershipsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def create
    p = membership_params
    if p[:code]
      invitation = Invitation.where(:code => p[:code]).first
      if invitation != nil and invitation.group_id == p[:group_id]
        p.delete :code
        @membership = current_user.memberships.create(p)
        invitation.update(:accepted => true)
        respond_with(@membership, :location => "#{api_memberships_url}/#{@membership.id}.json")
      else
        head :forbidden
      end
    else
      head :forbidden
    end
  end

  private
    def membership_params
      params.permit(:group_id, :code)
    end    
end  