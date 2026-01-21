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
        expect(region).name length
    end


    it "has a string representation that is its name" do
        name = 'Mt. Hood'
        region = Region.new(name: name)
        result = region.to_s
    end

end
