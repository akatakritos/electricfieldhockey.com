require 'spec_helper'

describe "level_sets/new" do
  before(:each) do
    assign(:level_set, stub_model(LevelSet,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new level_set form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", level_sets_path, "post" do
      assert_select "input#level_set_name[name=?]", "level_set[name]"
    end
  end
end
