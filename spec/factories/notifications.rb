FactoryGirl.define do
  factory :notification do
    user nil
    type 1
    content "MyText"
  end
end
