require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }

  describe 'Factory' do
    it 'should be valid' do
      user.should be_valid
    end

    it 'should not be admin' do
      user.should_not be_admin
    end
  end

  describe 'seo' do
    it 'has the username in the param' do
      user.to_param.should include(user.username)
    end
  end

  describe 'saves in lowercase' do
    it 'saves email in lower case' do
      mixed_case_email = 'MbRjWDjl@jfMjs.cOm'
      user.email = mixed_case_email
      user.save
      user.reload.email.should == mixed_case_email.downcase
    end
  end

  describe 'mass assignment' do
    it 'should not allow mass assignment to admin' do
      admin_attempt = User.create(:admin => true)
      admin_attempt.admin.should be_false
    end
  end

  describe 'validations' do
    describe 'username' do
      it 'must be present' do
        user.username = nil
        user.should_not be_valid
      end

      it 'must be more than 4 characters' do
        user.username = 'A'*3
        user.should_not be_valid
      end

      it 'must be less than 25 characters' do
        user.username = 'B'*26
        puts user.errors[:username]
        user.should_not be_valid
      end

      # it 'must be unique case insensitively' do
        
      #   other_user = user.dup
      #   user.save!

      #   other_user.username.upcase!
      #   other_user.valid?
      #   puts other_user.errors.full_messages.to_sentence
      #   other_user.should_not be_valid
      # end
    end

    describe 'name' do
      describe 'length' do
        it 'should have a valid factory' do
          user.should be_valid
        end

        it 'is not more than 50 characters' do
          user.name = 'C'*51
          user.should_not be_valid
        end

        it 'can be less than 50 characters' do
          user.name = 'B'*20
          user.should be_valid
        end

        it 'can be empty' do
          user.name = nil
          user.should be_valid
        end

      end
    end
  end

  describe 'authentication' do
    before(:each) do
      user = FactoryGirl.create(:user)
      user.password = 'foobar'
      user.password_confirmation = 'foobar'
      user.save
    end
    describe 'with correct password' do
      it 'should authenticate' do
        user.authenticate('foobar').should be_true
      end
    end

    describe 'with incorrect password' do
      it 'should not authenticate' do
        user.authenticate('fsdjfs').should be_false
      end
    end
  end
end
