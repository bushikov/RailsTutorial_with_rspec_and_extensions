class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->{ order( created_at: :desc ) }
  scope :including_replies, ->( id ){ where( in_reply_to: id ) }
  scope :my_posts, ->( id ){ where( user_id: id ) }
  scope :following_posts, ->( id ){
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    where( "user_id IN (#{ following_ids }) AND
            in_reply_to IS NULL", user_id: id )
  }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
                      length: { maximum: 140 }
  validate :picture_size

  private
    def picture_size
      if picture.size > 5.megabytes
        errors.add( :picture, "should be less than 5MB" )
      end
    end
end
