class Store < ApplicationRecord
  has_many :visit_records

  # 位置情報を利用するための設定
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode, if: ->(obj){ obj.latitude.blank? || obj.longitude.blank? }
end
