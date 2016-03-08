class Create < ActiveRecord::Migration
  def up
    create_table :lc_sections do |t|
      t.column :letters, :string, :null => false, :unique => true
      t.column :token, :integer, :null => false, :unique => true
      t.column :name, :string, :null => false
    end
  end

  def down
    drop_table :lc_sections
  end
end