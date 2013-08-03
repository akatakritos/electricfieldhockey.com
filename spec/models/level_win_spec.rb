require 'spec_helper'

describe LevelWin do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: level_wins
#
#  id         :integer         not null, primary key
#  level_id   :integer
#  level_json :string(255)
#  game_state :string(255)
#  attempts   :integer
#  time       :integer
#  created_at :datetime
#  updated_at :datetime
#

