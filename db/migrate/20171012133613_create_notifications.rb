class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.integer :type
      t.text :content

      t.timestamps
    end
    add_index :notifications, [ :user_id, :created_at ]
  end
end
