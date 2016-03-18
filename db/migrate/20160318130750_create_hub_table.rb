class CreateHubTable < ActiveRecord::Migration
  def up
    create_table :hub_lc_sections do |t|
      t.column :letters, :string, :null => false
      t.column :token, :integer, :null => false
      t.column :name, :string, :null => false
    end
    add_index :hub_lc_sections, :letters, :unique => true
    add_index :hub_lc_sections, :token, :unique => true
  end

  def down
    drop_table :hub_lc_sections
  end
end
