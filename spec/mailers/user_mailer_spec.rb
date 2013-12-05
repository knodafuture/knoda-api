require "spec_helper"

describe UserMailer do
  require 'mail'
  address = Mail::Address.new "support@knoda.com"
  address.display_name = "Knoda"    
    
  describe "signup" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.signup(user) }

    it "renders the headers" do
      mail.subject.should eq("Signup")
      mail.to.should eq([user.email])  
      mail.from.should eq([address.format])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "email_was_changed" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.email_was_changed(user) }

    it "renders the headers" do
      mail.subject.should eq("Email was changed")
      mail.to.should eq([user.email])
      mail.from.should eq([address.format])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "username_was_changed" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.username_was_changed(user) }

    it "renders the headers" do
      mail.subject.should eq("Username was changed")
      mail.to.should eq([user.email])
      mail.from.should eq([address.format])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
