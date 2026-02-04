require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TIcketsHelper. For example:
#
# describe TIcketsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TicketsHelper, type: :helper do
    describe "format phone number" do
        it "returns a correctly formated phone number string with US country code" do
            expect(helper.format_phone_number(:phone)).to eq(:phone)
        end
   end
end
