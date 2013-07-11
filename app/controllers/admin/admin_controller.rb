class Admin::AdminController < ApplicationController
  layout 'admin/layout'
  before_filter :require_admin, :except => [:sign_in, :sign_out]

  def sign_in

  end

  def sign_out

  end

  private

  def require_admin
    if current_user
      unless current_user.admin?
        render text: 'access denied', :status => 403
      end
    else
      redirect_to new_user_session_url
    end
  end
end
