require 'spec_helper'

describe 'Admin::Levels' do
  describe 'levels list' do
    #it_should_behave_like 'admin pages' do
      #let(:the_path) { admin_levels_path }
    #end

    describe 'content' do
      before do
        @level = FactoryGirl.create(:level)
        @user = FactoryGirl.create(:admin_user)
        sign_in @user
        visit(admin_levels_path)
      end

      it 'should have the levels in it' do
        expect(page).to have_content(@level.name)
      end

      it 'should have a delete link for the level' do
        expect(page).to have_link("Delete", 
                                  :href => admin_level_path(@level))
      end
    end

    describe 'deleting a level' do
      let(:level) { FactoryGirl.create(:level) }
      describe 'as a guest' do
        it 'send to sign in' do
          delete admin_level_path(level)
          response.should redirect_to signin_path
        end
      end

      describe 'as a signed in non-admin' do
        before do
          @user = FactoryGirl.create(:user)
          sign_in @user
        end
        it 'should send to root' do
          delete admin_level_path(level)
          response.should redirect_to root_path
        end
      end

      describe 'as an admin' do
        before do
          @user = FactoryGirl.create(:admin_user)
          sign_in @user
        end
        it 'should delete the level' do
          level.reload #make sure its inserted
          expect { delete admin_level_path(level)}.to change{Level.count}.by(-1)
        end
      end
    end

  end
end
