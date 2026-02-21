require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "#new_organization_application" do
    let(:test_email) { "admin@example.com" }
    let(:new_org) { build(:organization, name: "Test Org") }

    context "in production or test environment" do
      it "sends an email with correct recipient" do
        mail = UserMailer.with(to: test_email, new_organization: new_org).new_organization_application
        
        expect(mail.to).to eq([test_email])
      end
    end

    context "in development environment" do
      before do
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("development")) # stupid mock to simulate development environment
      end

      it "returns false" do
        result = UserMailer.with(to: test_email, new_organization: new_org).new_organization_application
        expect(result.message).to be_a(ActionMailer::Base::NullMail)
      end
    end
  end
end
