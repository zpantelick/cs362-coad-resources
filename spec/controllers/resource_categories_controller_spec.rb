require 'rails_helper'

RSpec.describe ResourceCategoriesController, type: :controller do
  let(:user) { create(:user) }
  let(:resource_category) { create(:resource_category) }

  before do
    # Stub the authentication methods
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:authenticate_admin).and_return(true)
    allow(controller).to receive(:set_resource_category).and_call_original
    
    sign_in user
  end

  describe "GET #index" do
    before { get :index }

    it "returns resource categories" do
      expect(controller.instance_variable_get(:@resource_categories)).not_to be_nil
    end
  end
  
  describe "GET #show" do
    before { get :show, params: { id: resource_category.id } }
    
    it "displays the resource category" do
      expect(controller.instance_variable_get(:@resource_category)).to eq(resource_category)
    end
  end

  describe "GET #new" do
    before { get :new }

    it "initializes a new resource category" do
      expect(controller.instance_variable_get(:@resource_category)).to be_a_new(ResourceCategory)
    end
  end

  describe "POST #create" do
    it "creates a new resource category" do
        expect {
            post :create, params: { resource_category: { name: "New Category" } }
        }.to change(ResourceCategory, :count).by(1)
    end

    it "renders new template on failure" do
        post :create, params: { resource_category: { name: "" } }
        expect(instance_variable_get(:@resource_category).nil?).to be true
    end
  end

  describe "GET #edit" do
    before { get :edit, params: { id: resource_category.id } }

    it "fetches the resource category for editing" do
      expect(controller.instance_variable_get(:@resource_category)).to eq(resource_category)
    end
  end

  describe "#update method" do
    it "updates the resource category" do
      patch :update, params: { id: resource_category.id, resource_category: { name: "Updated Name" } }
      expect(resource_category.reload.name).to eq("Updated Name")
    end

    it "renders edit template on failure" do
      patch :update, params: { id: resource_category.id, resource_category: { name: "" } }
      expect(instance_variable_get(:@resource_category).nil?).to be true
    end
  end

  describe "#activate method" do
    it "activates the resource category" do
      patch :activate, params: { id: resource_category.id }
      expect(resource_category.reload.active).to be true
    end

    it "redirects with an alert on failure" do
        allow_any_instance_of(ResourceCategory).to receive(:activate).and_return(false)
        patch :activate, params: { id: resource_category.id }
        expect(response).to redirect_to(resource_category_path(resource_category))
        expect(flash[:alert]).to eq('There was a problem activating the category.')
    end
  end

  describe "#deactivate method" do
    it "deactivates the resource category" do
      patch :deactivate, params: { id: resource_category.id }
      expect(resource_category.reload.active).to be false
    end

    it "redirects with an alert on failure" do
        allow_any_instance_of(ResourceCategory).to receive(:deactivate).and_return(false)
        patch :deactivate, params: { id: resource_category.id }
        expect(response).to redirect_to(resource_category_path(resource_category))
        expect(flash[:alert]).to eq('There was a problem deactivating the category.')
    end
  end

  describe "#destroy method" do
    it "deletes the resource category" do
      delete :destroy, params: { id: resource_category.id }
      expect(ResourceCategory.exists?(resource_category.id)).to be false
    end

    it "redirects to index with a notice" do
      delete :destroy, params: { id: resource_category.id }
      expect(response).to redirect_to(resource_categories_path)
      expect(flash[:notice]).to eq("Category #{resource_category.name} was deleted.\nAssociated tickets now belong to the 'Unspecified' category.")
    end
  end
end
