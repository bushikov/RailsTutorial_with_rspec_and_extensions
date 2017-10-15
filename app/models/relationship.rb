class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  after_save do
    followed.notifications.create( type: 1,
                                   content: "#{ follower.name } followed you." )
  end
end
