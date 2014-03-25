require 'spec_helper'

describe LevelsController do

  describe 'GET index' do
    it 'assigns @levels' do
      level = FactoryGirl.create(:level)
      get :index
      expect(assigns(:levels)).to eq([level])
    end
  end

  describe 'signed in actions' do
    before do
      @current_user = FactoryGirl.create(:user)
      sign_in @current_user
    end

    describe 'GET new' do
      it 'assigns @level' do
        get :new
        expect(assigns(:level)).to be_a_new(Level)
      end
    end

    describe 'POST create' do
      let(:level_json) {
        {
          :format => 'json',
          :level => {
            :name => 'My Level',
            :json => {
              "backgroundUrl" => 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABAQMAAAAl21bKAAAAA1BMVEUAAACnej3aAAAAAXRSTlMAQObYZgAAAApJREFUCB1jYAAAAAIAAc/INeUAAAAASUVORK5CYII=',
              "width" => 200,
              "height" => 100,
              "puckPosition" => {
                "x" => 50,
                "y" => 50,
              },
              "goal" => {
                "x" => 100,
                "y" => 100,
                "width" => 25,
                "height" => 25
              }
            }
          }
        }
      }
      it 'creates a level for the current user' do
        post :create, level_json
        expect(assigns(:level).creator).to eq(@current_user)
      end

      it 'creates a level with the right name' do
        post :create, level_json
        expect(assigns(:level).name).to eq('My Level')
      end

      it 'saves a file and rewrites the levels background url' do
        post :create, level_json

        level = assigns(:level)

        expect(level.json['backgroundUrl']).to match /\/uploads\/maps\/(.*)\.png/
      end

      it 'passes the json hash right to the json property (except backgroundUrl)' do
        post :create, level_json
        expect(assigns(:level).json.except('backgroundUrl')).to eq level_json[:level][:json].except("backgroundUrl")
      end

      it 'saves a valid png file' do
        post :create, level_json
        level = assigns(:level)
        expect(`file public/#{level.json['backgroundUrl']}`).to match /PNG image data/
      end
    end
  end



end
