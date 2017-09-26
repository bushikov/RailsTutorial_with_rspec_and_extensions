class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  default_scope ->{ order( created_at: :desc ) }

  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :content, presence: true,
                      length: { maximum: 140 }
  validate :mutual_follow

  private
    def mutual_follow
      # the presence validations of sender, receiver, sender_id,
      #  and receiver_id are executed.
      return unless sender && receiver
      unless ( sender.following.include?( receiver ) ) &&
        ( sender.followers.include?( receiver ) )
        errors.add( :relationship, "should be mutual follow" )
      end
    end
end
