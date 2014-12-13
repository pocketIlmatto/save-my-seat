class Category < ActiveRecord::Base
  include Sluggable
  validates :name, presence: true, uniqueness: true
  has_and_belongs_to_many :places
  sluggable_column :name
end