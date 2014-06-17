class Api::NotificationSettingsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  before_action :set_notification_setting, only: [:update]

  def index
    render json: current_user.notification_settings, status: 200, root: false
  end

  def update
    authorize_action_for(@notificationSetting)
    @notificationSetting.update(update_params)
    render json: @notificationSetting, status: 200
  end

  private
    def update_params
      params.permit(:active)
    end
    def set_notification_setting
      @notificationSetting = NotificationSetting.find(params[:id])
    end
end
