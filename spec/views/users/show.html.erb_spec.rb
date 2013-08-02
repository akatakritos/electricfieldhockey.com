require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :email => "Email",
      :username => "Username",
      :name => "Name",
      :admin => false,
      :password_digest => "Password Digest",
      :remember_token => "Remember Token"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Email/)
    rendered.should match(/Username/)
    rendered.should match(/Name/)
    rendered.should match(/false/)
    rendered.should match(/Password Digest/)
    rendered.should match(/Remember Token/)
  end
end
