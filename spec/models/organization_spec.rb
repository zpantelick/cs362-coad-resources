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
    expect(organization).to respond_to(:resource_categories)
  end

end
