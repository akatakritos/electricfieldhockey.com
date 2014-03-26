require 'spec_helper'

describe SessionsController do
  describe 'routing' do
    it 'routes #create' do
      expect(post('/sessions')).to route_to('sessions#create')
    end

    it 'routes #destroy' do
      expect(delete("/sessions/1")).to route_to('sessions#destroy',
                                               :id => '1')
    end

    it 'doesnt route the other things' do
      expect(get('/sessions')).to_not be_routable
      expect(get('/sessions/1')).to_not be_routable
      expect(put('/sessions/1')).to_not be_routable
    end

    it 'routes sigin' do
      expect(get('/signin')).to route_to('sessions#new')
    end

    it 'routes signout' do
      expect(delete('/signout')).to route_to('sessions#destroy')
    end
  end
end
