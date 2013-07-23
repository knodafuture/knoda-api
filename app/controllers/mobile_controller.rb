class MobileController < ApplicationController
	layout 'mobile/layout'
  skip_before_filter :authenticate_user_please!

  def index
  end
end
