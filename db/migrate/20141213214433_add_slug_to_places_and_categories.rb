class AddSlugToPlacesAndCategories < ActiveRecord::Migration
  def change
    add_column :places, :slug, :string
    add_column :categories, :slug, :string
  end
end
