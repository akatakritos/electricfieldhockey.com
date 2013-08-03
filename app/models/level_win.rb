class LevelWin < ActiveRecord::Base
  belongs_to :level, :counter_cache => true
  belongs_to :user

  default_scope order('attempts ASC')
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

