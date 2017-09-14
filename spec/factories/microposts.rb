FactoryGirl.define do
  factory :micropost do
    sequence( :content ){ Faker::Zelda.character }
    user nil

    factory :most_recent do
      created_at Time.zone.now
    end

    factory :two_hours_ago do
      created_at 2.hours.ago
    end

    factory :one_days_ago do
      created_at 1.days.ago
    end
  end
end
