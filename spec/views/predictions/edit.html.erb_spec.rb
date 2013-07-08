require 'spec_helper'

describe "predictions/edit" do
  before(:each) do
    @prediction = assign(:prediction, stub_model(Prediction,
      :user_id => 1,
      :text => "MyString",
      :closed => false,
      :closed_as => false
    ))
  end

  it "renders the edit prediction form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", prediction_path(@prediction), "post" do
      assert_select "input#prediction_user_id[name=?]", "prediction[user_id]"
      assert_select "input#prediction_text[name=?]", "prediction[text]"
      assert_select "input#prediction_closed[name=?]", "prediction[closed]"
      assert_select "input#prediction_closed_as[name=?]", "prediction[closed_as]"
    end
  end
end
