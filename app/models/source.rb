class Source < ActiveRecord::Base
  has_many :place_statistics
  has_many :api_links
  validates :name, presence: true  

  def self.transform_measurement(measure, capacity, num_buckets)
    if num_buckets > 0
      bucket = capacity/num_buckets
      for i in 1..num_buckets
        if measure <= i*bucket
          break
        end
      end
      i-1
    else
      0
    end
  end

end