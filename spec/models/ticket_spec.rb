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
    it "belongs to region (optional)" do
        should belong_to(:region).optional
    end

    it "validates presence of required fields" do
        should validate_presence_of(:name)
        should validate_presence_of(:phone)
        should validate_presence_of(:region_id)
        should validate_presence_of(:resource_category_id)
    end

    it "has valide phone number" do
        should validate_phony_plausible_of(:phone)
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

        if "scopes open tickets" do
            expect(Ticket.open).to include(ticket)
        end

        it "scopes closed tickets" do
            expect(Ticket.closed).to include(closed_ticket)
        end
    end

end
