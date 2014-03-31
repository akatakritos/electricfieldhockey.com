class Level < ActiveRecord::Base
  require 'json'
  before_save :json_serialize
  after_save :json_deserialize
  after_find :json_deserialize

  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  has_many :level_wins

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

  def to_param
    "#{id}-#{name}".parameterize
  end

  
  def self.newest
    self.order("created_at desc, id desc").first
  end

  def self.hardest
    # mult 0.1 to force floating pt division (at least in sqlite)
    self.where("view_count >= 10").order("level_wins_count * 0.1 / view_count asc").first
  end

  def self.random(options = {})
    excluding = options.fetch(:excluding) {  []  }
    conditions = [" id not in (?)", excluding] if excluding.any?

    self.first(:order => random_function, 
               :conditions => conditions)
  end

  private
    def self.random_function
      case self.connection.adapter_name.downcase
        when /sqlite/
          "RANDOM()"
        when /mysql/
          "RANDOM()";
      end
    end
end

# == Schema Information
#
# Table name: levels
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  json             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  creator_id       :integer
#  view_count       :integer         default(0)
#  level_wins_count :integer         default(0)
#

