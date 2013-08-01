require 'spec_helper'

describe "level_sets/show" do
  before(:each) do
    @level_set = assign(:level_set, stub_model(LevelSet,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
