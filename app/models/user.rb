class User < ActiveRecord::Base
  has_secure_password
  validates :username, presence: true
  validates :username, uniqueness: true
  enum status: [:online, :playing, :offline]

  def to_s
    username
  end

  def new_invite?
    if match = Match.find_by("status = ? AND ? = ANY(players)", 1, id)
      match.id
    else
      false
    end
  end

  def self.exclude(user)
    user.nil? ? User.all : User.where.not(id: user.id)
  end
end
