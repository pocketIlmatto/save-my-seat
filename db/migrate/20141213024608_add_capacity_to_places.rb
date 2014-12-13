class AddCapacityToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :capacity, :integer
  end
end
