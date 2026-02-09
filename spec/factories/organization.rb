FactoryBot.define do
    factory :organization do
        name { generate( :name ) }
        email { generate( :email ) }
        phone { generate( :phone ) }
        primary_name { :name }
        secondary_name { generate( :name )}
        secondary_phone { generate( :phone ) }
        status { :submitted } 
    end
end