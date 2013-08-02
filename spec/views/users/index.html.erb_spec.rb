require 'spec_helper'

describe "users/index" do
  before(:each) do
    assign(:users, [
      stub_model(User,
        :email => "Email",
        :username => "Username",
        :name => "Name",
        :admin => false,
        :password_digest => "Password Digest",
        :remember_token => "Remember Token"
      ),
      stub_model(User,
        :email => "Email",
        :username => "Username",
        :name => "Name",
        :admin => false,
        :password_digest => "Password Digest",
        :remember_token => "Remember Token"
      )
    ])
  end

  it "renders a list of users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Username".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Password Digest".to_s, :count => 2
    assert_select "tr>td", :text => "Remember Token".to_s, :count => 2
  end
end
