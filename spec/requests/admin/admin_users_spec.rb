require 'spec_helper'

def modify_user(user, properties={})
  visit edit_admin_user_path(user)
  properties.each do |key,value|
    if !!value == value
      find(:css, "#user_#{key}").set(true)
    else
      fill_in "user_#{key}", :with => value
    end
  end
  click_button "Update User"
end

describe "Admin::Users" do
  describe 'users list' do

    it_should_behave_like 'admin pages' do
      let(:the_path) { admin_users_path }
    end
  end

  describe 'editing a user' do
    let(:user) { FactoryGirl.create(:user) }
    let(:new_name) { "New Name" }
    let(:new_username) { "New Username" }
    let(:new_email) { "New Email" }

    before :each do
      @admin_user = FactoryGirl.create(:admin_user)
      @user = user
      sign_in @admin_user
      modify_user(@user, :name => new_name, :username => new_username, :email => new_email)
    end

    it 'should change the users properties' do
      @user = @user.reload
      @user.name.should eq new_name
      @user.email.should eq new_email.downcase
      @user.username.should eq new_username
    end

    it 'should redirect back to the users show page' do
      current_path.should == admin_user_path(@user.reload)
    end

    it 'should not sign the admin out when editing himself' do
      modify_user(@admin_user)
      signed_in?(@admin_user).should be_true
    end

    describe 'making a user an admin' do
      before do
        @user = user
        modify_user(@user, :admin => true)
      end

      it 'should make the user an admin' do
        @user.reload.admin?.should be_true
      end
    end

    describe 'removing admin status from a user' do
      before do
        @user = FactoryGirl.create(:admin_user)
        modify_user(@user, :admin => false)
      end

      it 'should remove the admin flag' do
        @user.reload.admin?.should be_false
      end
    end
  end
end
