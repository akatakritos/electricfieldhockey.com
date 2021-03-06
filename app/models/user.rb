require 'bcrypt'
class User < ActiveRecord::Base
  attr_accessor :password_confirmation
  attr_reader :password
  attr_protected :admin 

  has_many :levels, :foreign_key => 'creator_id'

  validates_length_of :name, :maximum => 50
  validates :username, :length => {:maximum => 25, :minimum => 4},
                        :presence => true,
                        :uniqueness => { :case_sensitive => :false }

  validates_confirmation_of :password, :if => lambda { |m| m.password.present? }
  validates_presence_of :password, :on => :create
  validates_presence_of :password_confirmation, :on => :create

  before_save do |user|
    # only update the auth token if the password was changed: effectively logging them out
    user.remember_token = SecureRandom.hex unless @password.blank?
    user.email.downcase! if user.email
  end

  def authenticate(unencrypted_password)
    BCrypt::Password.new(password_digest) == unencrypted_password && self
  end

  def to_param
    "#{self.id}-#{self.username}".parameterize
  end

  def password=(unencrypted_password)
    unless unencrypted_password.blank?
      @password = unencrypted_password
      cost = BCrypt::Engine::DEFAULT_COST
      self.password_digest = BCrypt::Password.create(unencrypted_password, :cost => cost)
    end
  end
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

