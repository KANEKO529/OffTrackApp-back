class VisitRecord < ApplicationRecord
  # belongs_to :user
  belongs_to :store
  belongs_to :user, optional: true
  

  validates :store_id, presence: true
  validates :date, presence: true
end
