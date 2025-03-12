class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :nickname, presence: true
end
