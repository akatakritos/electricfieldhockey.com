require 'spec_helper'

describe LevelWinsController do
  describe 'routing' do

    it 'routes #create' do
      expect(post('/level_wins')).to route_to('level_wins#create')
    end

    it 'does not route the other resources' do
      expect(get('/level_wins')).to_not be_routable
      expect(get('/level_win/1')).to_not be_routable
      expect(get('/level_wins/new')).to_not be_routable
      expect(get('/level_wins/1/edit')).to_not be_routable
      expect(put('/level_wins/1')).to_not be_routable
    end

    it 'routes /replay/:id as #show' do
      expect(get('/replay/1')).to route_to('level_wins#show',
                                           :id => '1')
    end
  end
end
