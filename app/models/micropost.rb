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

  after_save do
    if reply?
      user_to_reply_to.notifications.create( type: 3,
                        content: "#{ user.name } replied to you." )
    end
  end

  private
    def picture_size
      if picture.size > 5.megabytes
        errors.add( :picture, "should be less than 5MB" )
      end
    end

    def reply?
      !!matched_thing_to_reply_to
    end

    def user_to_reply_to
      User.find_by( name: matched_thing_to_reply_to[ 2 ] )
    end

    def matched_thing_to_reply_to
      /\A(@)([\w\s.-]+)(\r\n)/.match( content )
    end
end
