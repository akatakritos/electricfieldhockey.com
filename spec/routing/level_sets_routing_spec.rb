require "spec_helper"

describe LevelSetsController do
  describe "routing" do

    it "routes to #index" do
      get("/level_sets").should route_to("level_sets#index")
    end

    it "routes to #new" do
      get("/level_sets/new").should route_to("level_sets#new")
    end

    it "routes to #show" do
      get("/level_sets/1").should route_to("level_sets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/level_sets/1/edit").should route_to("level_sets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/level_sets").should route_to("level_sets#create")
    end

    it "routes to #update" do
      put("/level_sets/1").should route_to("level_sets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/level_sets/1").should route_to("level_sets#destroy", :id => "1")
    end

  end
end
