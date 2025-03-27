class User < ApplicationRecord
  has_many :visit_records, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :nickname, presence: true, uniqueness: true
end
