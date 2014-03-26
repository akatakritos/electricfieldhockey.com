require 'spec_helper'

describe UsersController do
  describe 'routing' do
    it 'routes #create' do
      expect(post('/users')).to route_to('users#create')
    end

    it 'routes #show' do
      expect(get('/users/1')).to route_to('users#show',
                                          :id => '1')
    end

    it 'routes #index' do
      expect(get('/users')).to route_to('users#index')
    end

    it 'doesnt route the other resources' do
      expect(get('/user/new')).to_not be_routable
      expect(put('/users/1')).to_not be_routable
    end

    it 'routes /signup as #new' do
      expect(get('/signup')).to route_to('users#new')
    end
  end
end
