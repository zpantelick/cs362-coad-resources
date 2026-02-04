FactoryBot.define do
    factory :organization do
        name { "Test Organization" }
        email { "org@example.com" }
        phone { "555-1234" }
        primary_name { "John Doe" }
        secondary_name { "Jane Doe" }
        secondary_phone { "555-5678" }
        status { :submitted } 
    end
end