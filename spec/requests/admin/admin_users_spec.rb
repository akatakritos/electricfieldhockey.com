require 'spec_helper'

describe "Admin::Users" do
  describe 'users list' do

    it_should_behave_like 'admin pages' do
      let(:the_path) { admin_users_path }
    end
  end
end
