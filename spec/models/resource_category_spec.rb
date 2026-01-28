require 'rails_helper'

RSpec.describe ResourceCategory, type: :model do

let(:resourceCat) { ResourceCategory.new(name: "TEST", active: true) }

  describe "Class tests" do # Class & Method testing
    it "exists" do
      ResourceCategory.new
    end

    it "has a string representation that is its name" do
      result = resourceCat.to_s
      expect(result).to eq("TEST")
    end

    it "has a way to check active status" do
      expect(resourceCat).to respond_to(:inactive?)
    end
  end

  describe "Schema Attribute Testing" do # Attribute Testing
    it "has a name" do
      expect(resourceCat).to respond_to(:name)
    end

    it "has a status" do
      expect(resourceCat).to respond_to(:active)
    end
  end

  describe "Association Testing" do # Association Testing
    it "has and belongs to many organizations" do
      should have_and_belong_to_many(:organizations)
    end

    it "has many tickets" do
      should have_many(:tickets)
    end
  end

  describe "Validation Testing" do # Validation testing
    it "has a name" do
      should validate_presence_of(:name)
    end

    it "has a name with between 1 - 255 chars" do
      should validate_length_of(:name).is_at_least(1).is_at_most(255).on(:create)
    end

    it "has a unique, non case sensitive name" do
      should validate_uniqueness_of(:name).case_insensitive()
    end
  end

end
