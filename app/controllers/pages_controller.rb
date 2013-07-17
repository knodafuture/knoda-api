class PagesController < ApplicationController
  skip_before_filter :authenticate_user_please!
  
  def index
  end

  def about
  end

  def terms
  end
end
