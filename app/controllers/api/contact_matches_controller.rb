class Api::ContactMatchesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def create
    if params[:facebook]
      render :json => current_user.facebook_friends_on_knoda, :root => false
    else
      contacts = params['_json']
      User.uncached do
        contacts.each do |i|
          u = User.where('email in (?) OR phone in (?)', i[:emails], i[:phones]).first
          if u
            i[:knoda_info] = {:user_id => u.id, :username => u.username}
          end
        end
      end
      render :json => contacts, :root => false
    end
  end

  private
end
