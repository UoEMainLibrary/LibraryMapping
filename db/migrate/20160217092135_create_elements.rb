class CreateElements < ActiveRecord::Migration
  def up
    create_table :elements do |t|
      t.belongs_to :element_type, :index => true
      t.column :left, :float, :null => false
      t.column :right, :float, :null => false
      t.column :width, :integer, :null => false
      t.column :height, :integer, :null => false
      t.column :rotation, :float, :null => false, :default => 0.0
      t.column :fill, :string
      t.column :opacity, :float, :null => false, :default => 1.0
      t.timestamps null: false
    end
  end

  def down
    drop_table :elements
  end
end