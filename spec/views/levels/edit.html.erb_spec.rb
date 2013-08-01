require 'spec_helper'

describe "levels/edit" do
  before(:each) do
    @level = assign(:level, stub_model(Level,
      :name => "MyString",
      :json => "MyString"
    ))
  end

  it "renders the edit level form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", level_path(@level), "post" do
      assert_select "input#level_name[name=?]", "level[name]"
      assert_select "input#level_json[name=?]", "level[json]"
    end
  end
end
