require 'rails_helper'

RSpec.describe Region, type: :model do

    it "exists" do
        Region.new
    end

    let (:region) { Region.new }

    it "has a name" do
        expect(region).to respond_to(:name)
    end

    it "validates length of name" do
        should validate_length_of(:name)
          .is_at_least(1)
          .is_at_most(255)
          .on(:create)
    end


    it "has a string representation that is its name" do
        name = 'Mt. Hood'
        region = Region.new(name: name)
        result = region.to_s
        expect(result).to eq(name)
    end

    it "unspecified method works" do
        region = Region.unspecified
        expect(region.name).to eq('Unspecified')
    end

end
