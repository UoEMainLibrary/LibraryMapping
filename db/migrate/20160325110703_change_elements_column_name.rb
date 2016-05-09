class ChangeElementsColumnName < ActiveRecord::Migration
  def change
    rename_column :elements, :width, :right
    rename_column :elements, :height, :bottom
  end
end
