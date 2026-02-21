require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  
  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:authenticate_admin).and_call_original
    allow(controller).to receive(:verify_unapproved).and_call_original
    allow(controller).to receive(:verify_approved).and_call_original
    allow(controller).to receive(:verify_user).and_call_original
    allow(controller).to receive(:set_organization).and_call_original

    sign_in user
  end

  describe "GET #index" do
    before { get :index }

    it "returns organizations" do
      expect(controller.instance_variable_get(:@organizations)).not_to be_nil
    end
  end

  describe "GET #new" do
    before { get :new }

    it "makes new organization" do
      expect(controller.instance_variable_get(:@organization)).to be_a_new(Organization)
    end
  end

  describe "POST #create" do
    let(:valid_params) { { organization: attributes_for(:organization) } }

    before do
      allow(controller).to receive(:verify_approved).and_return(true)

      # Stub the mailer to prevent actual email delivery
      mailer = double('mailer')
      allow(UserMailer).to receive(:with).and_return(mailer)
      allow(mailer).to receive(:new_organization_application).and_return(mailer)
      allow(mailer).to receive(:deliver_now)
    end

    context "with valid parameters" do
      it "creates a new orginization with submitted status" do
        post :create, params: valid_params
        expect(Organization.last.status).to eq("submitted")
      end

      it "associates organization with current user" do
        post :create, params: valid_params
        expect(user.reload.organization).to eq(Organization.last)
      end

      it "redirects to path" do
        post :create, params: valid_params
        expect(response).to redirect_to(organization_application_submitted_path)
      end

    end
  end
      

end
