class Change < ActiveRecord::Migration
  def change
    rename_column :elements, :right, :top
    rename_column :elements, :rotation, :angle
  end
end
