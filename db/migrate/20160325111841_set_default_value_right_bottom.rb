class SetDefaultValueRightBottom < ActiveRecord::Migration
  def change
    change_column :elements, :right, :integer, :default => 0
    change_column :elements, :bottom, :integer, :default => 0
  end
end
