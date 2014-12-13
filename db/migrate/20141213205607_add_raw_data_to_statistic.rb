class AddRawDataToStatistic < ActiveRecord::Migration
  def change
    add_column :place_statistics, :raw_data, :text
    add_column :place_statistics, :raw_data_type, :string
  end
end
