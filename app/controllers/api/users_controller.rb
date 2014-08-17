class Api::UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_user, :only => [:show, :predictions, :update]
  skip_before_filter :authenticate_user_please!, :only => [:show, :predictions, :create]

  respond_to :json

  def show
    respond_with(@user)
  end

  def predictions
    @predictions = @user.predictions.visible_to_user(current_user).latest.id_lt(param_id_lt)

    if derived_version >= 2
      serializer = PredictionFeedSerializerV2
      respond_with(@predictions.offset(param_offset).limit(param_limit),
        root: false,
        each_serializer: serializer)
    else
      serializer = PredictionFeedSerializer
      respond_with(@predictions.offset(param_offset).limit(param_limit),
        root: false,
        meta: pagination_meta(@predictions),
        each_serializer: serializer)
    end
  end

  def autocomplete
    @users = User.search(params[:query], fields: [{:username => :text_start}], limit: 10)
    render json: @users
  end

  def update
    authorize_action_for(@user)
    if @user.update(user_update_params)
      render json: @user, status: 200
    else
      render json: @user.errors, status: 422
    end
  end

  def create
    u = user_create_params
    if not u[:password]
      u[:password] = Devise.friendly_token[0,6]
    end
    if not u[:username]
      u[:username] = "GuestTemp#{rand(100000)}"
    end
    u[:guest_mode] = true
    u[:email] = nil
    @user = User.create!(u)
    @user.username = "Guest#{@user.id}"
    if @user.avatar.blank?
      av = (1 + rand(5))
      p = Rails.root.join('app', 'assets', 'images', 'avatars', "avatar_#{av}@2x.png")
      @user.avatar_from_path p
    end
    if @user.authentication_token.nil?
      @user.reset_authentication_token!
    end
    @user.save!
    return render :json => {:success => true, :auth_token => @user.authentication_token}, :status => 201
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_update_params
      return params.permit(:username, :email, :password, :phone)
    end

    def user_create_params
      {}
    end
end
