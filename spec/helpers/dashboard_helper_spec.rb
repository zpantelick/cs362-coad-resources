require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the DashboardHelper. For example:
#
# describe DashboardHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe DashboardHelper, type: :helper do

    setup do
        @user = build(:user)  # will need an organization id for other tests - refer to /spec/factories/user.rb
    end

    it "Returns the creation application for users with no organization" do
        @user.organization = nil
        expect(helper.dashboard_for(@user)).to eq('create_application_dashboard')
    end

    it "Returns admin dashboard when user is admin" do
        @user.role = 'admin'
        expect(helper.dashboard_for(@user)).to eq('admin_dashboard')
    end

    it "Returns organization submitted dashboard when organization is submitted" do
        org = create(:organization, status: :submitted)
        @user.organization = org
        expect(helper.dashboard_for(@user)).to eq('organization_submitted_dashboard')
    end

    it "Returns organization approved dashboard when organization is approved" do
        org = create(:organization, status: :approved)
        @user.organization = org
        expect(helper.dashboard_for(@user)).to eq('organization_approved_dashboard')
    end

end
