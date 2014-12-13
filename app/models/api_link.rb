class ApiLink < ActiveRecord::Base
  belongs_to :place
  belongs_to :source
  #TODO validate uniqueness of place+source
end