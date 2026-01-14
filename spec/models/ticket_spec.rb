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
    it "belongs to region" do
        should belong_to(:region).optional
    end

end
