# spec/factories/goals.rb
FactoryGirl.define do
  factory :goal do
    name { Faker::Lorem.word }
  end
end