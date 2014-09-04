class Api::ContactMatchesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def create
    if params[:facebook]
      render :json => current_user.facebook_friends_on_knoda, :root => false
    elsif params[:twitter]
      render :json => current_user.twitter_friends_on_knoda, :root => false
    else
      contacts = params['_json']
      contacts.each do |i|
        u = User.where('email in (?) OR phone in (?)', i[:emails], i[:phones]).first
        if u
          i[:knoda_info] = {:user_id => u.id, :username => u.username, :avatar_image => u.avatar_image, :following => current_user.led_by?(u)}
        end
      end
      render :json => contacts, :root => false
    end
  end

  private
end
