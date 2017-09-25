FactoryGirl.define do
  factory :message do
    sequence( :content ){ Faker::Zelda.character }

    after( :build ) do | message |
      user1 = create( :unspecified )
      user2 = create( :unspecified )
      message.sender_id = user1.id
      message.receiver_id = user2.id
    end
  end
end
