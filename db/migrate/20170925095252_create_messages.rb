class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :sender_id
      t.integer :receiver_id

      t.timestamps
    end
    add_index :messages, :sender_id
    add_index :messages, :receiver_id
  end
end
