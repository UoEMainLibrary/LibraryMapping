class CreateFeedbackTable < ActiveRecord::Migration
  def up
    create_table :feedback_messages do |t|
      t.column :name, :string
      t.column :email, :string
      t.column :message, :string
      t.timestamps null: false
    end
  end

  def down
    drop_table :feedback_messages
  end
end
