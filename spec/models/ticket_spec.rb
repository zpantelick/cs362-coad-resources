require 'rails_helper'

RSpec.describe Ticket, type: :model do

    it "exists" do
        Ticket.new
    end

    let (:ticket) { Ticket.new }
    let (:region) { Region.create(name: 'Test Region') }
    let (:resource_category) { ResourceCategory.create(name: 'Test Category') }

    it "responds to name" do
        expect(ticket).to respond_to(:name)
        expect(ticket).to respond_to(:description)
        expect(ticket).to respond_to(:phone)
    end

    it "belongs to region" do
        should belong_to(:region)
    end

    # Do this for the optional ones
    it "belongs to organization (optional)" do
        should belong_to(:organization).optional
    end

    it "validates presence of required fields" do
        should validate_presence_of(:name)
        should validate_presence_of(:phone)
    end

    it "has valid phone number" do
        ticket = Ticket.new(
            name: 'Test Phone',
            phone: '+15035551234',
            region: region,
            resource_category: resource_category
        )
        expect(ticket).to be_valid
    end

    describe "to_s method" do
        let (:ticket) { Ticket.new(id: 5) }
        it "returns valid ticket id" do
            expect(ticket.to_s).to eq("Ticket 5")
        end
    end

    describe "scope tests" do
        let!(:open_ticket) do
            Ticket.create!(
                name: 'Test',
                phone: '+15035551234',
                region: region,
                resource_category: resource_category,
                organization: nil,
                closed: false
            )
        end

        let!(:closed_ticket) do
            Ticket.create!(
                name: 'Closed Test',
                phone: '+15035551235',
                region: region,
                resource_category: resource_category,
                closed: true
            )
        end

        it "scopes open tickets" do
            expect(Ticket.open).to include(open_ticket)
        end

        it "scopes closed tickets" do
            expect(Ticket.closed).to include(closed_ticket)
        end
    end

end
