class Api::MembershipsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def create
    @membership = current_user.memberships.create(membership_params)
    respond_with(@membership, :location => "#{api_memberships_url}/#{@membership.id}.json")
  end

  private
    def membership_params
      params.permit(:group_id)
    end    
end  