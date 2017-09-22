FactoryGirl.define do
  factory :relationship do
    factory :one_side do
      after( :build ) do | rel |
        rel.follower_id = create( :unspecified ).id
        rel.followed_id = create( :unspecified ).id
      end
    end

    factory :mutual_follow do
      before( :create ) do | rel |
        other_rel = create( :one_side )
        rel.follower_id = other_rel.followed_id
        rel.followed_id = other_rel.follower_id
      end
    end
  end
end
