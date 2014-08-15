class Api::ContactMatchesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def create
    contacts = params['_json']
    User.uncached do
      contacts.each do |i|
        u = User.order('random()').first
        i[:knoda_info] = {:user_id => u.id, :username => u.username}
      end
    end
    render :json => contacts, :root => false
  end

  private
end
