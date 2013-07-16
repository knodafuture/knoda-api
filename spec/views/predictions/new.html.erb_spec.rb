require 'spec_helper'

describe "predictions/new" do
  before(:each) do
    assign(:prediction, stub_model(Prediction,
      :user_id => 1,
      :text => "MyString",
      :closed => false,
      :closed_as => false
    ).as_new_record)
  end

  it "renders new prediction form" do
    pending
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", predictions_path, "post" do
      assert_select "input#prediction_user_id[name=?]", "prediction[user_id]"
      assert_select "input#prediction_text[name=?]", "prediction[text]"
      assert_select "input#prediction_closed[name=?]", "prediction[closed]"
      assert_select "input#prediction_closed_as[name=?]", "prediction[closed_as]"
    end
  end
end
