class Notification < ApplicationRecord
  self.inheritance_column = :_type_disabled
  belongs_to :user
  validates :type, presence: true
  validates :content, presence: false
end
