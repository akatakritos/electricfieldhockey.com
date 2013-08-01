require 'spec_helper'

describe "level_sets/edit" do
  before(:each) do
    @level_set = assign(:level_set, stub_model(LevelSet,
      :name => "MyString"
    ))
  end

  it "renders the edit level_set form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", level_set_path(@level_set), "post" do
      assert_select "input#level_set_name[name=?]", "level_set[name]"
    end
  end
end
