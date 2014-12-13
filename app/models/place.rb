class Place < ActiveRecord::Base
  include Sluggable
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  after_validation :reverse_geocode, if: ->(obj){ obj.longitude.present? and obj.latitude.present? and (obj.latitude_changed? or obj.longitude_changed?) }

  geocoded_by :address   # can also be an IP address
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.city    = geo.city
      obj.zip     = geo.postal_code
      obj.country = geo.country_code
      obj.state   = geo.state
      obj.address = geo.address
    end
  end
  
  has_many :place_statistics
  has_many :api_links
  has_and_belongs_to_many :categories

  sluggable_column :name

  validates :name, presence: true
  
  def latest_statistic
    self.place_statistics.last
  end

  def latest_statistic_by_source(source_id)
    self.place_statistics.where(source_id: source_id).last
  end

  def latest_measurement
    self.latest_statistic.nil? ? PlaceStatistic.measurements[:dead] : self.latest_statistic.measurement
  end
  
end