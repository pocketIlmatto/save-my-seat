class Place < ActiveRecord::Base
  
  geocoded_by :address   # can also be an IP address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.city    = geo.city
      obj.zip     = geo.postal_code
      obj.country = geo.country_code
      obj.state   = geo.state
    end
  end
  after_validation :reverse_geocode, if: ->(obj){ obj.longitude.present? and obj.latitude.present? and (obj.longitude_changed? or obj.longitude.changed?) }

  has_many :place_statistics
  has_many :api_links
  
  def latest_measurement
    self.place_statistics.last
  end

  
end