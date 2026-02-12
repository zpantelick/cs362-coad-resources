require 'rails_helper'

RSpec.describe RegionsController, type: :controller do
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
        let (:user) { create(:user, :admin) }
        before(:each) { sign_in user }

        it {
            expect(get(:index)).to be_successful
        }

        it {
            post(:create, params: { region: FactoryBot.attributes_for(:region) })
            expect(response).to redirect_to regions_path
        }
    end
end
