class UpdateElementRanges < ActiveRecord::Migration
  def change
    add_column :elements, :range_up_opt, :string
    add_column :elements, :range_up_letters, :string
    add_column :elements, :range_up_digits, :string

    add_column :elements, :range_down_opt, :string
    add_column :elements, :range_down_letters, :string
    add_column :elements, :range_down_digits, :string
  end
end
