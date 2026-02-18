require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
    describe "GET #index" do
        before do
            sign_in user
            get :index
        end

        shared_examples "successful index response" do
            it "returns a successful response" do
                expect(response).to be_successful
            end

            it "assigns @pagy and @tickets" do
                expect(controller.instance_variable_get(:@pagy)).not_to be_nil
                expect(controller.instance_variable_get(:@tickets)).not_to be_nil
            end
        end

        context "with a default user" do
            let(:user) { create(:user) }

            it "assigns @status_options for a default user" do
                status_options = controller.instance_variable_get(:@status_options)
                expect(status_options).to eq(['Open'])
            end

            include_examples "successful index response"
        end

        context "with an approved organization user" do
            let(:organization) { create(:organization, status: :approved) }
            let(:user) { create(:user, organization: organization) }

            it "assigns @status_options for an approved organization" do
                status_options = controller.instance_variable_get(:@status_options)
                expect(status_options).to eq(['Open', 'My Captured', 'My Closed'])
            end

            include_examples "successful index response"
        end

        context "with an admin user" do
            let(:user) { create(:user, :admin) }

            it "assigns @status_options for an admin" do
                status_options = controller.instance_variable_get(:@status_options)
                expect(status_options).to eq(['Open', 'Captured', 'Closed'])
            end

            include_examples "successful index response"
        end
    end

    describe "tickets method" do
        let(:organization) { create(:organization, status: :approved) }
        let(:user) { create(:user, organization: organization) }

        before do
            sign_in user
        end

        def expect_tickets_for(status, expected_scope)
            allow(controller).to receive(:pagy).and_return([:pagy, expected_scope])
            params = status.nil? ? {} : { status: status }
            get :index, params: params
            expect(controller.instance_variable_get(:@tickets)).to eq(expected_scope)
        end

        context "when status is 'Open'" do
            it "returns open tickets" do
                expect_tickets_for('Open', Ticket.open)
            end
        end

        context "when status is 'Closed'" do
            it "returns closed tickets" do
                expect_tickets_for('Closed', Ticket.closed)
            end
        end

        context "when status is 'Captured'" do
            it "returns all organization tickets" do
                expect_tickets_for('Captured', Ticket.all_organization)
            end
        end

        context "when status is 'My Captured'" do
            it "returns organization tickets for the current user's organization" do
                expect_tickets_for('My Captured', Ticket.organization(organization.id))
            end
        end

        context "when status is 'My Closed'" do
            it "returns closed organization tickets for the current user's organization" do
                expect_tickets_for('My Closed', Ticket.closed_organization(organization.id))
            end
        end

        context "when status is not specified" do
            it "returns all tickets" do
                expect_tickets_for(nil, Ticket.all)
            end
        end
    end
end
