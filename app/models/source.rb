class Source < ActiveRecord::Base
  has_many :place_statistics
  has_many :api_links
  
end