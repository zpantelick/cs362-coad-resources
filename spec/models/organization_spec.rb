require 'rails_helper'

RSpec.describe Organization, type: :model do
  it 'exists' do
    Organization.new
  end

  let (:organization) { Organization.new }

  it 'has an email' do
    expect(organization).to respond_to(:email)
  end

  it 'has a name' do
    expect(organization).to respond_to(:name)
  end

  it 'has a phone' do
    expect(organization).to respond_to(:phone)
  end

  it 'has status' do
    expect(organization).to respond_to(:status)
  end

  it 'has a primary name' do
    expect(organization).to respond_to(:primary_name)
  end

  it 'has a secondary name' do
    expect(organization).to respond_to(:secondary_name)
  end

  it 'has a secondary phone' do
    expect(organization).to respond_to(:secondary_phone)
  end

  it 'has/belongs to a resource category' do
    should has_and_belongs_to_many(:resource_categories)
  end

  it "has many users" do
    should have_many(:users)
  end

  it "has many tickets" do
    should have_many(:tickets)
  end

  describe "validations" do
    it "validates length of email" do
      should validate_length_of(:email)
        .is_at_least(1)
        .is_at_most(255)
        .on(:create)
    end

    it "validates uniqueness of email" do
      should validate_uniqueness_of(:email).case_insensitive
    end

    it "validates length of name" do
      should validate_length_of(:name)
        .is_at_least(1)
        .is_at_most(255)
        .on(:create)
    end

    it "validates uniqueness of name" do
      should validate_uniqueness_of(:name).case_insensitive
    end

    it "validates length of description" do
      should validate_length_of(:description)
        .is_at_most(1020)
        .on(:create)
    end
  end

  describe "to_s method" do 
    let (:organization) { Organization.new(name: 'john doe') }
    it "returns valid name" do
      expect(organization.to_s).to eq('john doe')
    end
  end

end
