class CreateUsageStatisticsTable < ActiveRecord::Migration
  def up
    create_table :usage_statistics do |t|
      t.column :found, :boolean, :null => false
      t.timestamps null: false
    end
  end

  def down
    drop_table :usage_statistics
  end
end
