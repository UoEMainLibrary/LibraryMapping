class UpdateElementTypes < ActiveRecord::Migration
  def change
    add_column :element_types, :svg_path, :string
    add_column :elements, :floor, :integer
  end
end