class AddCapacityAndHeirarchyToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :capacity, :integer
    add_column :categories, :hidden, :boolean
    add_column :categories, :parent_category_id, :integer
  end
end
