class AddWidthAndHeightForTypes < ActiveRecord::Migration
  def change
    add_column :element_types, :width, :float
    add_column :element_types, :height, :float
  end
end
