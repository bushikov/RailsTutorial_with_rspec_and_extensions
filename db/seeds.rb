User.create!( name: "Example User",
              email: "example@railstutorial.org",
              admin: true,
              activated: true,
              activated_at: Time.zone.now,
              password: "foobar",
              password_confirmation: "foobar" )

99.times do | n |
  name = Faker::Name.name
  email = "example-#{ n + 1 }@railstutorial.org"
  password = "password"
  User.create!( name: name,
                email: email,
                activated: true,
                activated_at: Time.zone.now,
                password: password,
                password_confirmation: password )
end

users = User.order( :created_at ).take( 6 )
50.times do
  content = Faker::Lorem.sentence( 5 )
  users.each{ | user | user.microposts.create!( content: content ) }
end

users = User.all
user = users.first
following = users[ 2 .. 50 ]
followers = users[ 3 .. 40 ]
following.each{ | followed | user.follow( followed ) }
followers.each{ | follower | follower.follow( user ) }

Message.create!( content: "Hello! It's message!",
                 sender_id: user.id,
                 receiver_id: followers[ 0 ].id )
Message.create!( content: "Thank you for your message!",
                 sender_id: followers[ 0 ].id,
                 receiver_id: user.id )
