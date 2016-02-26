class AddRangeAnndClassificationToElements < ActiveRecord::Migration
  def change
    add_column :elements, :range_up, :float
    add_column :elements, :range_down, :float
    add_column :elements, :classification, :string
    add_column :elements, :identifier, :string
  end
end