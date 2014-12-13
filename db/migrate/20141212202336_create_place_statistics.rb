class CreatePlaceStatistics < ActiveRecord::Migration
  def change
    create_table :place_statistics do |t|
      t.integer :place_id
      t.integer :source_id
      t.integer :measurement, default: 1
      t.timestamps
    end
  end
end
