class VisitRecord < ApplicationRecord
  # belongs_to :user
  belongs_to :store

  validates :store_id, presence: true
  validates :date, presence: true
end
