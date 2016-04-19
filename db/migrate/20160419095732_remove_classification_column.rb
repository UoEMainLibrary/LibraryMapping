class RemoveClassificationColumn < ActiveRecord::Migration
  def up
    remove_column :elements, :classification
  end

  def down
    add_column :elements, :classification, :string
  end
end
