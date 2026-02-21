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

    it "creates new organization" do
      expect(controller.instance_variable_get(:@organizations)).to be_a_new(Organization)
    end
  end
      

end
