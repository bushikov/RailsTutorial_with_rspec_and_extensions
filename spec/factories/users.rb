FactoryGirl.define do
  factory :user do
    name "Michael Example"
    email "michael@example.com"
    # password_digest User.digest( "password" )
    password "password"
    password_confirmation "password"
    activated true
    activated_at Time.zone.now

    factory :michael do
      name "Admin Michael"
      email "admin@admin.com"
      admin true
    end

    factory :archer do
      name "Sterling Archer"
      email "duchess@example.gov"
      password "password"
      password_confirmation "password"
    end

    factory :lana do
      name "Lana Kane"
      email "hands@example.gov"
      password "password"
      password_confirmation "password"
    end

    factory :malory do
      name "Malory Archer"
      email "boss@example.gov"
      password "password"
      password_confirmation "password"
    end

    factory :unspecified do
      sequence( :name ){ Faker::Name.name }
      sequence( :email ){ | n | "example-#{ n }@example.com" }
      password "password"
      password_confirmation "password"
    end

    factory :not_activated do
      activated false
      activated_at nil
    end
  end
end
