class PlaceStatistic < ActiveRecord::Base
  validates :place_id, presence: true
  validates :source_id, presence: true
  belongs_to :place
  belongs_to :source
  enum measurement: [:dead, :light, :busy, :packed]
end