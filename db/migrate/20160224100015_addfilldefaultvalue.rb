class Addfilldefaultvalue < ActiveRecord::Migration
  def change
    change_column :elements, :fill, :string, :default => 0
  end
end