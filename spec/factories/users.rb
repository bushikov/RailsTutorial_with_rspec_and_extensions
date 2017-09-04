FactoryGirl.define do
  factory :user do
    name "Michael Example"
    email "michael@example.com"
    # password_digest User.digest( "password" )
    password "password"
    password_confirmation "password"
  end
end
