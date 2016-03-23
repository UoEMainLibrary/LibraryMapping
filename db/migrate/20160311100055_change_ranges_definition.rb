class ChangeRangesDefinition < ActiveRecord::Migration
  def up
    change_column :elements, :range_up, :decimal, precision: 9, scale: 5
    change_column :elements, :range_down, :decimal, precision: 9, scale: 5
  end

  def down
    change_column :elements, :range_up, :float
    change_column :elements, :range_down, :float
  end
end
