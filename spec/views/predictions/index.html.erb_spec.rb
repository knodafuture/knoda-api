require 'spec_helper'

describe "predictions/index" do
  before(:each) do
    assign(:predictions, [
      stub_model(Prediction,
        :user_id => 1,
        :text => "Text",
        :closed => false,
        :closed_as => false
      ),
      stub_model(Prediction,
        :user_id => 1,
        :text => "Text",
        :closed => false,
        :closed_as => false
      )
    ])
  end

  it "renders a list of predictions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Text".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
