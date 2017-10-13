class Notification < ApplicationRecord
  self.inheritance_column = :_type_disabled
  belongs_to :user
  default_scope ->{ order( created_at: :desc ) }
  validates :type, presence: true
  validates :content, presence: false
end
