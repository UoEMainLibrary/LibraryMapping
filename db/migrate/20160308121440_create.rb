class Create < ActiveRecord::Migration
  def up
    create_table :lc_sections do |t|
      t.column :letters, :string, :null => false
      t.column :token, :integer, :null => false
      t.column :name, :string, :null => false
    end
    add_index :lc_sections, :letters, :unique => true
    add_index :lc_sections, :token, :unique => true
  end

  def down
    drop_table :lc_sections
  end
end