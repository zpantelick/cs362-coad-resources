FactoryBot.define do
    factory :ticket do
        name { "Test Ticket" }
        description { "This is a test ticket." }
        phone { "+15035551234" }
        region
        resource_category
    end
end