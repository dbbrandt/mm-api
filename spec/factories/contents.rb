# spec/factories/contents.rb
# Contents are either of type Prompt (ex. qestion) or criterion.rb
FactoryGirl.define do
  factory :content do
    type "Prompt"
    description nil
    image_url nil
    copy { Faker::Lorem.word }
    score 0.0
    descriptor nil
    interaction_id nil
  end
end