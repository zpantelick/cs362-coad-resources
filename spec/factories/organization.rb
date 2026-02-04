FactoryBot.define do
    factory :organization do
        name { "Test Organization" }
        status { :submitted } 
    end
end