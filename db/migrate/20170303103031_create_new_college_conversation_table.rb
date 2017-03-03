class CreateNewcollegeConversionTable < ActiveRecord::Migration
  def up
    create_table :newcollege_sections do |t|
      t.column :letters, :string, :null => false
      t.column :token, :integer, :null => false
      t.column :name, :string, :null => false
    end
    add_index :newcollege_sections, :letters, :unique => true
    add_index :newcollege_sections, :token, :unique => true
  end

  def down
    drop_table :newcollege_sections
  end
end
