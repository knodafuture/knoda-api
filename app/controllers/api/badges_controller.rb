class Api::BadgesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user_please!, :only => [:available]
  respond_to :json

  def index
    if derived_version < 2
      respond_with([])
    else
      respond_with([], root: false)
    end
  end

  def recent
    @badges = []
    if derived_version < 2
      respond_with(@badges)
    else
      respond_with(@badges, root: false)
    end
  end

  def available
    @badges = []
    respond_with(@badges, root: false)
  end
end
