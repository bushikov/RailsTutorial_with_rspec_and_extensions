class Notification < ApplicationRecord
  self.inheritance_column = :_type_disabled
  belongs_to :user
  default_scope ->{ where( "informed = ?", false ) \
                    .order( created_at: :desc ) }
  validates :type, presence: true
  validates :content, presence: false

  after_find do | n |
    n.update_attribute( :informed, true ) unless n.informed
  end
end
