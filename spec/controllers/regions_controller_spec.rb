require 'rails_helper'

RSpec.describe RegionsController, type: :controller do
    shared_context "as admin" do
        let (:user) { create(:user, :admin) }
        before(:each) { sign_in user }
    end

    describe "as a logged-out user" do
        let (:user) { create(:user) }
        
        it {
            expect(get(:index)).to redirect_to(new_user_session_path)
        }

        it {
            # pp attributes_for( :region )  # how to print things in spec, i forgot so this is for me
            post(:create, params: { region: FactoryBot.attributes_for(:region) })
            expect(response).to redirect_to new_user_session_path  # shorthand for response = post(...)
        }
    end

    describe "as a logged-in user" do
        let (:user) { create(:user) }
        before(:each) { sign_in user }

        it {
            expect(get(:index)).to redirect_to(dashboard_path)
        }

        it {
            post(:create, params: { region: FactoryBot.attributes_for(:region) })
            expect(response).to redirect_to dashboard_path
        }
        
    end

    describe "as an admin user" do
        include_context "as admin"

        it {
            expect(get(:index)).to be_successful
        }

        it {
            post(:create, params: { region: FactoryBot.attributes_for(:region) })
            expect(response).to redirect_to regions_path
        }

        it {
            post(:create, params: { region: FactoryBot.attributes_for(:region, name: nil) })
            expect(response).to have_http_status(:ok)
            expect(response).not_to redirect_to regions_path
        }
    end

    describe "show method" do
        let (:region) { create(:region) }
        include_context "as admin"

        it {
            get(:show, params: { id: region.id })
            expect(response).to be_successful
        }
    end

    describe "new method" do
        include_context "as admin"

        it {
            get(:new)
            expect(response).to be_successful
        }
    end

    describe "edit method" do
        let (:region) { create(:region) }
        include_context "as admin"

        it {
            get(:edit, params: { id: region.id })
            expect(response).to be_successful
        }
    end

    describe "update method" do
        context "with valid attributes" do
            let (:region) { create(:region) }
            include_context "as admin"

            it {
                patch(:update, params: { id: region.id, region: FactoryBot.attributes_for(:region) })
                expect(response).to redirect_to region_path(region)
            }
        end

        context "with invalid attributes" do
            let (:region) { create(:region) }
            include_context "as admin"

            it {
                patch(:update, params: { id: region.id, region: FactoryBot.attributes_for(:region, name: nil) })
                expect(response).to have_http_status(:ok)
                expect(response).not_to redirect_to(region_path(region))
            }
        end
    end

    describe "destroy method" do
        let (:region) { create(:region) }
        include_context "as admin"

        it {
            delete(:destroy, params: { id: region.id })
            expect(response).to redirect_to regions_path
        }
    end

end
