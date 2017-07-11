# spec/factories/import_rows.rb
FactoryGirl.define do
  factory :import_row do
    title { Faker::Lorem.word }
    json_data { "{\"title\": \"#{Faker::Lorem.word}\",\"answer_type\": \"ShortAnswer\"}" }
    import_file { }
  end
end