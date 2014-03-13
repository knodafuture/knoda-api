class Api::InvitationsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_invitation, only: [:show]
  respond_to :json

  def create
    if params[:group_id]
      @invitation = current_user.invitations.create(invitation_params)
      respond_with(@invitation, :serializer => InvitationSerializer, :status => 401)
    else
      @invitations = []
      params[:_json].each do | invitation_list_params |
        invitation = current_user.invitations.create(invitation_list_params)
        @invitations << invitation
      end
      respond_with(@invitations, :each_serializer => InvitationSerializer, :status => 401, :location => "/groups")
    end
  end

  def show
    respond_with(@invitation)
  end

  def invitation_url(invitation)
    "/api/invitations/#{invitation.id}.json"
  end

  private
    def invitation_params
      params.permit([:_json, :group_id, :recipient_email, :recipient_user_id, :recipient_phone])
    end    
    def set_invitation
      @group = Group.find(params[:id])
    end    
end  