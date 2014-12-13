class ExpandAddressColumnsOnPlaces < ActiveRecord::Migration
  def change
    remove_column :places, :address
    rename_column :places, :lat, :latitude
    rename_column :places, :lon, :longitude
    add_column :places, :city, :string
    add_column :places, :state, :string
    add_column :places, :zip, :string
    add_column :places, :country, :string
  end
end
