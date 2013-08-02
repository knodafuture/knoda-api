require "spec_helper"

describe ReportsMailer do
  before(:all) do
    pending
  end
  
  describe "daily" do
    let(:mail) { ReportsMailer.daily }

    it "renders the headers" do
      mail.subject.should eq("Daily")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
