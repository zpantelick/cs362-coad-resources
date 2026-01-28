require 'rails_helper'

RSpec.describe User, type: :model do
    it "exists" do
        User.new
    end

    let (:user) { User.new }

    it "has an email" do
        expect(user).to respond_to(:email)
    end

    it "has a password" do
        expect(user).to respond_to(:password)
    end

    it "has a role" do
        expect(user).to respond_to(:role)
    end
    
    it "belongs to organization (optional)" do
        should belong_to(:organization).optional
    end

    describe "validations" do
        it "validates presence of email" do
            should validate_presence_of(:email)
        end

        it "validates length of email" do
            should validate_length_of(:email)
              .is_at_least(1)
              .is_at_most(255)
              .on(:create)
        end

        it "validates uniqueness of email" do
            should validate_uniqueness_of(:email).case_insensitive
        end

        it "validates presence of password on create" do
            should validate_presence_of(:password).on(:create)
        end

        it "validates length of password on create" do
            should validate_length_of(:password)
              .is_at_least(7)
              .is_at_most(255)
              .on(:create)
        end
    end

    describe "to_s method" do
        let (:user) { User.new(email: 'rando@gmail.com') }
        it "returns valid email" do
            expect(user.to_s).to eq('rando@gmail.com')
        end
    end
end
