require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
    describe "new method" do
        before do
            sign_in create(:user)
            get :new
        end

        it "returns a successful response" do
            expect(response).to be_successful
        end

        it "assigns @ticket" do
            expect(controller.instance_variable_get(:@ticket)).to be_a_new(Ticket)
        end
    end

    describe "create method" do
        let(:user) { create(:user, :admin) }
        let(:valid_params) do
          {
            name: "Test Ticket",
            description: "This is a test ticket.",
            phone: "5551234567",
            region_id: create(:region).id,
            resource_category_id: create(:resource_category).id
          }
        end
        let(:invalid_params) { { name: "", description: "" } }

        before do
            allow(controller).to receive(:authenticate_admin).and_return(true)
            sign_in user
        end

        it "creates a new ticket with valid parameters" do
            expect {
                post :create, params: { ticket: valid_params }
            }.to change(Ticket, :count).by(1)
            
            ticket = Ticket.find_by(name: "Test Ticket")
            expect(ticket).not_to be_nil
            expect(ticket.description).to eq("This is a test ticket.")
        end

        it "does not create a ticket with invalid parameters" do
            expect {
                post :create, params: { ticket: invalid_params }
            }.not_to change(Ticket, :count)
        end
    end
end
