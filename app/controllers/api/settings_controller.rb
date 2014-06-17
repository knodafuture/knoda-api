class Api::SettingsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def index
    j = []
    j << {:name => "Notification Settings", :settings => ActiveModel::ArraySerializer.new(current_user.notification_settings, each_serializer: NotificationSettingSerializer)}
    respond_with(j, status: 200, root: false)
  end

  def android
  end
end
