require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  email           :string(50)
#  username        :string(25)      not null
#  name            :string(50)
#  admin           :boolean         default(FALSE), not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

