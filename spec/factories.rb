FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "21091091"
    password_confirmation "21091091"
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end


end