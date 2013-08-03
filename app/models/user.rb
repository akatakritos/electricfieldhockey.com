require 'bcrypt'
class User < ActiveRecord::Base
  attr_accessor :password_confirmation
  attr_reader :password
  attr_protected :admin 

  has_many :levels, :foreign_key => 'creator_id'

  validates_length_of :name, :maximum => 50
  validates :username, :length => {:maximum => 30, :minimum => 4},
                        :presence => true,
                        :uniqueness => { :case_sensitive => :false }

  validates_confirmation_of :password, :if => lambda { |m| m.password.present? }
  validates_presence_of :password, :on => :create
  validates_presence_of :password_confirmation, :on => :create

  before_save do |user|
    user.remember_token = SecureRandom.hex
  end

  def authenticate(unencrypted_password)
    BCrypt::Password.new(password_digest) == unencrypted_password && self
  end

  def to_param
    "#{self.id}-#{self.username}"
  end

  def password=(unencrypted_password)
    unless unencrypted_password.blank?
      @password = unencrypted_password
      cost = BCrypt::Engine::DEFAULT_COST
      self.password_digest = BCrypt::Password.create(unencrypted_password, :cost => cost)
    end
  end
end
