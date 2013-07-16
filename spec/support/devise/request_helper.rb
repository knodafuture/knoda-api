module DeviseRequestHelper

  # for use in request specs
  def sign_in_as_a_valid_user
    @user = FactoryGirl.create(:user)
    post user_session_path, 'user[login]' => @user.username, 'user[password]' => @user.password
  end
end
