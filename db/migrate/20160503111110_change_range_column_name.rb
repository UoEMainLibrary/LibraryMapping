class ChangeRangeColumnName < ActiveRecord::Migration
  def change
    rename_column :elements, :range_up, :range_end
    rename_column :elements, :range_up_digits, :range_end_digits
    rename_column :elements, :range_up_letters, :range_end_letters
    rename_column :elements, :range_up_opt, :range_end_opt
    
    rename_column :elements, :range_down, :range_start
    rename_column :elements, :range_down_digits, :range_start_digits
    rename_column :elements, :range_down_letters, :range_start_letters
    rename_column :elements, :range_down_opt, :range_start_opt
  end
end
