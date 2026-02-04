require 'rails_helper'

RSpec.describe ResourceCategory, type: :model do

setup do
	@resourceCatBuild = build(:resource_category, :name => "TEST")
end

  	describe "Class tests" do # Class & Method testing

		it "exists" do
			@resourceCatBuild
		end

		it "has a string representation that is its name" do
			result = @resourceCatBuild.to_s
			expect(result).to eq("TEST")
		end

		it "has a way to check active status" do
			expect(@resourceCatBuild).to respond_to(:inactive?)
		end

		it "unspecified method works" do
			resource = ResourceCategory.unspecified
			expect(resource.name).to eq('Unspecified')
		end

		it "active method works" do 
			resource = FactoryBot.build(:resource_category, active: false)
			expect(resource.inactive?).to be_truthy()
			resource.activate
			expect(resource.inactive?).to be_falsey()
		end

		it "deactivate method works" do 
			resource = FactoryBot.build(:resource_category, :active => true)
			expect(resource.inactive?).to be_falsey()
			resource.deactivate()
      		expect(resource.inactive?).to be_truthy()
		end

  	end

  	describe "Schema Attribute Testing" do # Attribute Testing
		it "has a name" do
			expect(@resourceCatBuild).to respond_to(:name)
		end

		it "has a status" do
			expect(@resourceCatBuild).to respond_to(:active)
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

	describe "scope tests" do
		let!(:active_resource) do
			ResourceCategory.create!(
				name: 'Active Test',
				active: true
			)
		end

		let!(:inactive_resource) do
			ResourceCategory.create!(
				name: 'Inactive Test',
				active: false
			)
		end

		it "scopes active resource categories" do
			expect(ResourceCategory.active).to include(active_resource)
		end

		it "scopes inactive resource categories" do
			expect(ResourceCategory.inactive).to include(inactive_resource)
		end
	end
end
