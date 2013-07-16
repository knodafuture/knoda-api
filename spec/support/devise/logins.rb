module DeviseLogins

  def login_as_user
    user = FactoryGirl.create(:user)
    #FactoryGirl.create(:school, :with_semesters, users: [user])
    before(:each) { sign_in user }
    user
  end
end
