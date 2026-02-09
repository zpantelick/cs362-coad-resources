FactoryBot.define do

    factory :user do
        email { "user@example.com" }
        password { "foopass123" }
        organization_id { }  # will need an org id, but that should probably be taken from an organization factory, so it references it correctly
                             # ie. ":organization_id" from spec/factories/organization.rb when that exists
        before(:create) { |user| user.skip_confirmation! }

        trait :admin do
            role { :admin }
        end
    end
end