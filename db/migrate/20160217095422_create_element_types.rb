class CreateElementTypes < ActiveRecord::Migration
  def change
    create_table :element_types do |t|
      t.column :name, :string, :null => false
      t.timestamps null: false
    end
  end
end
