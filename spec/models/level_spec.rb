require 'spec_helper'

describe Level do
  pending "add some examples to (or delete) #{__FILE__}"
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

