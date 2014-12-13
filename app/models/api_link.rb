class ApiLink < ActiveRecord::Base
  belongs_to :place
  belongs_to :source
  validates_uniqueness_of :place_id, scope: :source_id
  validates_uniqueness_of :api_key, scope: :source_id
end