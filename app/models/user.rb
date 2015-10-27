class User < ActiveRecord::Base
  has_secure_password
  validates :username, presence: true
  validates :username, uniqueness: true
  enum status: [:online, :playing, :offline]

  def to_s
    username
  end
end
