require "spec_helper"

describe UserMailer do
  describe "signup" do
    let(:mail) { UserMailer.signup }

    it "renders the headers" do
      mail.subject.should eq("Signup")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "email_was_changed" do
    let(:mail) { UserMailer.email_was_changed }

    it "renders the headers" do
      mail.subject.should eq("Email was changed")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "username_was_changed" do
    let(:mail) { UserMailer.username_was_changed }

    it "renders the headers" do
      mail.subject.should eq("Username was changed")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
