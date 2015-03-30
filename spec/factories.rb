FactoryGirl.define do
  factory :user do
    name "Serge"
    email  "example@railstutorial.org"
    password '123'
    password_confirmation '123'
  end
end 