class Level < ActiveRecord::Base
  require 'json'
  before_save :json_serialize
  after_save :json_deserialize
  after_find :json_deserialize

  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'

  def json_serialize
    self.json = self.json.to_json
  end

  def json_deserialize
    self.json = JSON.parse(json)
  end

  def set_defaults
    self.json =  {
      "name" => "Level Name",
      "width" => 800,
      "height" => 450,
      "goal" => {
        "x" => 775,
        "y" => 175,
        "width" => 25,
        "height" => 100
      },
      "backgroundUrl" => "",
      "puckPosition" => {
        "x"  => 100,
        "y" => 50
      },
      "startingCharges" => '1,-1,1,-1,1,-1'
    }
  end
end
