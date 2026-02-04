require 'rails_helper'

RSpec.describe Region, type: :model do

    let(:region) { build(:region, :name => "A name") }  # option 1 for factory building
    let(:region) { create(:region, :name => "A name") }  # used for adding an actual item to the database

    setup do    # option 2 for factory building
        @region1 = build(:region, :name => "Region1");
        @region2 = build(:region, :name => "Region2");
    end

    it "exists" do
        @region1
    end

    let (:region) { Region.new }  # old

    it "has a name" do
        expect(region).to respond_to(:name)
    end

    it "validates length of name" do
        should validate_length_of(:name)
          .is_at_least(1)
          .is_at_most(255)
          .on(:create)
    end

    it "has many tickets" do
        should have_many(:tickets)
    end

    it "has a string representation that of its name" do
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
