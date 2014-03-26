require 'spec_helper'

describe LevelsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get("/levels")).to route_to('levels#index')
    end

    it 'routes to #show' do
      expect(get("/levels/1")).to route_to('levels#show', :id => '1')
    end

    it 'routes to #new' do
      expect(get('/levels/new')).to route_to('levels#new')
    end

    it 'routes to #create' do
      expect(post('/levels')).to route_to('levels#create')
    end

    it 'routes the scoreboard subroute to level_wins' do
      expect(get('levels/1/scoreboard')).to route_to('level_wins#index',
                                                     :level_id => '1')
    end
  end
end
