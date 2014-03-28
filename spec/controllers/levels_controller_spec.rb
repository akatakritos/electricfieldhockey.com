require 'spec_helper'

describe LevelsController do

  describe 'GET index' do
    it 'assigns @levels' do
      level = FactoryGirl.create(:level)
      get :index
      expect(assigns(:levels)).to eq([level])
    end

    describe 'pagination and sorting' do
      it 'paginates to 12' do
        15.times { FactoryGirl.create(:level) }
        get :index
        expect(assigns(:levels).length).to eq(12)
      end

      
      describe 'sorting by create date' do
        let!(:first) { FactoryGirl.create(:level) }
        let!(:second) { sleep(0.5); FactoryGirl.create(:level) }

        it 'sorts by create date by default' do
          get :index
          expect(assigns(:levels)).to eq [first, second]
        end

        it 'can sort asc' do
          get :index, 'sort' => 'age'
          expect(assigns(:levels)).to eq([first, second])
        end

        it 'can sort desc' do
          get :index, 'sort' => 'age', 'dir' => 'desc'
          expect(assigns(:levels)).to eq([second, first])
        end
      end


      describe 'sorting by views' do
        let!(:first) { FactoryGirl.create(:level, :view_count => 100) }
        let!(:second) { FactoryGirl.create(:level, :view_count => 10) }
        it 'can sort by views asc' do
          get :index, "sort" => "views", "dir" => "asc"
          expect(assigns(:levels)).to eq([second, first])
        end
        it 'can sort by views desc' do
          get :index, "sort" => "views", "dir" => "desc"
          expect(assigns(:levels)).to eq([first, second])
        end
      end

      describe 'sorting by wins' do
        let!(:first) { FactoryGirl.create(:level, :level_wins_count => 100) }
        let!(:second) { FactoryGirl.create(:level, :level_wins_count => 10) }
        it 'can sort by wins asc' do
          get :index, 'sort' => 'wins', 'dir' => 'asc'
          expect(assigns(:levels)).to eq [second, first]
        end
        it 'can sort by wins desc' do
          get :index, 'sort' => 'wins', 'dir' => 'desc'
          expect(assigns(:levels)).to eq [first, second]
        end
      end
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

      # delete the saved background image if it exists
      after(:each) do
        if assigns(:level)
          background_file = 'public' + assigns(:level).json['backgroundUrl']

          FileUtils.rm background_file if File.exist?(background_file)
        end
      end

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
        image_file = 'public' + level.json['backgroundUrl']

        expect(File.exist?(image_file)).to be_true
        expect(`file #{image_file}`).to match /PNG image data/
      end
    end
  end



end
