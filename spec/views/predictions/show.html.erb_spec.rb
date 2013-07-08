require 'spec_helper'

describe "predictions/show" do
  before(:each) do
    @prediction = assign(:prediction, stub_model(Prediction,
      :user_id => 1,
      :text => "Text",
      :closed => false,
      :closed_as => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Text/)
    rendered.should match(/false/)
    rendered.should match(/false/)
  end
end
