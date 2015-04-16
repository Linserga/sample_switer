FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}"}
    sequence(:email) { |n| "person_#{n}@example.com"}
    password '123'
    password_confirmation '123'
    activated true
    activated_at Time.now.to_datetime
  end
end 