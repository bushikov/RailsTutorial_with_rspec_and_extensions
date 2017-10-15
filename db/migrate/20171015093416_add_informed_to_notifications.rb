class AddInformedToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :informed, :boolean, default: false
  end
end
