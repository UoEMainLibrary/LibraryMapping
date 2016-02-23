class Add < ActiveRecord::Migration
  def change
    add_column :elements, :scaleX, :float
    add_column :elements, :scaleY, :float
  end
end
