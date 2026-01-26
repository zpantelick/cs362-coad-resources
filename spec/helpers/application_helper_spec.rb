require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
    describe "test full title" do
        it "works with no page title" do
            expect(helper.full_title).to eq "Disaster Resource Network"
        end
        it "works with a page title" do
            expect(helper.full_title("Contact")).to eq "Contact | Disaster Resource Network"
        end
    end
end
