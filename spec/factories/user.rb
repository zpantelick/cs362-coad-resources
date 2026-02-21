FactoryBot.define do

    factory :user do
        email { generate(:email) }
        password { "foopass123" }
        organization_id { }
        organization { nil }
        before(:create) { |user| user.skip_confirmation! }

        trait :admin do
            role { :admin }
        end
    end
end