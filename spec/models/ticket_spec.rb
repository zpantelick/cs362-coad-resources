require 'rails_helper'

RSpec.describe Ticket, type: :model do

    it "exists" do
        Ticket.new
    end

    let (:ticket) { Ticket.new }

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
        expect(Ticket.new(phone: "5035551234")).to plausible(:phone)
    end

    describe "to_s method" do
        let (:ticket) { Ticket.new(id: 5) }
        it "returns valid ticket id" do
            expect(ticket.to_s).to eq("Ticket 5")
        end
    end

    describe "scope tests" do
        let (:ticket) { Ticket.new(organization: nil)}
        let (:closed_ticket) { Ticket.new(closed: true) }

        it "scopes open tickets" do
            expect(Ticket.open).to include(ticket)
        end

        it "scopes closed tickets" do
            expect(Ticket.closed).to include(closed_ticket)
        end
    end

end
