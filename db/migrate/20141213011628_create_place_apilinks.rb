class CreatePlaceApilinks < ActiveRecord::Migration
  def change
    create_table :api_links do |t|
      t.string :api_key
      t.integer :place_id
      t.integer :source_id
      t.timestamps
    end
  end
end
