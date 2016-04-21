class AddLibraryColumnToElements < ActiveRecord::Migration
  def up
    add_column :elements, :library, :string
  end

  def down
    remove_column :elements, :library
  end
end
