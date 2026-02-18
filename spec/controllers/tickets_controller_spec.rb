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

    describe "show method" do
        let(:ticket) { create(:ticket) }

        it "returns redirect to dashboard if not authenticated" do
            sign_in create(:user)
            get :show, params: { id: ticket.id }
            expect(response).to redirect_to(dashboard_path)
        end

        it "finds ticket if authenticated" do
            sign_in create(:user, :admin)
            get :show, params: { id: ticket.id }
            expect(controller.instance_variable_get(:@ticket)).to eq(ticket)
        end
    end

    describe "capture method" do
        let(:ticket) { create(:ticket) }

        it "returns redirect to dashboard if not authenticated" do
            sign_in create(:user)
            post :capture, params: { id: ticket.id }
            expect(response).to redirect_to(dashboard_path)
        end

        it "captures ticket if authenticated and valid ticket" do
            organization = create(:organization, status: :approved)
            user = create(:user, organization: organization)
            sign_in user
            post :capture, params: { id: ticket.id }
            expect(response).to redirect_to(dashboard_path + '#tickets:open')
            expect(ticket.reload.organization_id).to eq(organization.id)
        end

        it "does not capture ticket if authenticated but invalid ticket" do
            organization = create(:organization, status: :approved)
            user = create(:user, organization: organization)
            ticket_already_captured = create(:ticket, organization: organization)
            sign_in user
            post :capture, params: { id: ticket_already_captured.id }
            expect(response).to have_http_status(200)
        end
    end

    describe "release method" do
        it "goes to dashboard if not authenticated" do
            sign_in create(:user)
            post :release, params: { id: create(:ticket).id }
            expect(response).to redirect_to(dashboard_path)
        end

        it "releases ticket if authenticated and valid ticket" do
            organization = create(:organization, status: :approved)
            user = create(:user, organization: organization)
            ticket = create(:ticket, organization: organization)
            sign_in user
            post :release, params: { id: ticket.id }
            expect(response).to redirect_to(dashboard_path + '#tickets:organization')
            expect(ticket.reload.organization_id).to be_nil
        end

        it "releases ticket if authenticated and valid ticket for admin" do
            organization = create(:organization, status: :approved)
            user = create(:user, :admin, organization: organization)
            ticket = create(:ticket, organization: organization)
            sign_in user
            post :release, params: { id: ticket.id }
            expect(response).to redirect_to(dashboard_path + '#tickets:captured')
            expect(ticket.reload.organization_id).to be_nil
        end

        it "ticket release not ok" do
            organization = create(:organization, status: :approved)
            user = create(:user, organization: organization)
            other_org = create(:organization, status: :submitted)
            ticket = create(:ticket, organization: other_org)
            sign_in user
            post :release, params: { id: ticket.id }
            expect(response).to have_http_status(200)
            expect(ticket.reload.organization_id).to eq(other_org.id)
        end
    end

    describe "close method" do
        it "goes to dashboard if not authenticated" do
            sign_in create(:user)
            post :close, params: { id: create(:ticket).id }
            expect(response).to redirect_to(dashboard_path)
        end

        it "redirects to #tickets:open if admin and close successful" do
            organization = create(:organization, status: :approved)
            user = create(:user, :admin, organization: organization)
            ticket = create(:ticket, organization: organization)
            sign_in user
            post :close, params: { id: ticket.id }
            expect(response).to redirect_to(dashboard_path + '#tickets:open')
        end

        it "redirects to #tickets:organization if not admin and close successful" do
            organization = create(:organization, status: :approved)
            user = create(:user, organization: organization)
            ticket = create(:ticket, organization: organization)
            sign_in user
            post :close, params: { id: ticket.id }
            expect(response).to redirect_to(dashboard_path + '#tickets:organization')
        end

        it "renders show if close not successful" do
            organization = create(:organization, status: :approved)
            user = create(:user, organization: organization)
            other_org = create(:organization, status: :submitted)
            ticket = create(:ticket, organization: other_org)
            sign_in user
            post :close, params: { id: ticket.id }
            expect(response).to have_http_status(200)
            expect(ticket.reload.closed).to be false
        end
    end

    describe "destroy method" do
        it "destroys the ticket" do
            organization = create(:organization, status: :approved)
            user = create(:user, :admin, organization: organization)
            ticket = create(:ticket, organization: organization)
            sign_in user
            expect {
                delete :destroy, params: { id: ticket.id }
            }.to change(Ticket, :count).by(-1)
            expect(response).to redirect_to(dashboard_path + '#tickets')
            expect(flash[:notice]).to eq("Ticket #{ticket.id} was deleted.")
        end
    end
end
