class Api::InvitationsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_invitation, only: [:show]
  respond_to :json

  def create
    @invitation = current_user.invitations.create(invitation_params)
    respond_with(@invitation, :serializer => InvitationSerializer, :status => 401)
  end

  def show
    respond_with(@invitation)
  end

  def invitation_url(invitation)
    "/api/invitations/#{invitation.id}.json"
  end

  private
    def invitation_params
      params.permit(:group_id, :recipient_email, :recipient_user_id)
    end    
    def set_invitation
      @group = Group.find(params[:id])
    end    
end  