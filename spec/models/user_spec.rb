require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:password) }
  end

  describe 'custom validations' do
    context 'length checks - minimum' do
      let(:user) { build(:user, :with_wrong_min_password_length) }

      it 'user with below min length shouldnt be saved' do
        expect(user).not_to be_valid
        expect(user.errors.full_messages.first).to include 'too short'
      end
    end

    context 'length checks - maximum' do
      let(:user) { build(:user, :with_wrong_max_password_length) }

      it 'user with above max length shouldnt be saved' do
        expect(user).not_to be_valid
        expect(user.errors.full_messages.first).to include 'too long'
      end
    end

    context 'atleast one number' do
      let(:user) { build(:user, :without_atleast_one_number_password) }

      it 'user without atleast one number password shouldnt be saved' do
        expect(user).not_to be_valid
        expect(user.errors.full_messages.first).to include 'atleast one number'
      end
    end

    context 'lower letter case' do
      let(:user) { build(:user, :without_atleast_one_lower_letter_password) }

      it 'user without one lower letter password shouldnt be saved' do
        expect(user).not_to be_valid
        expect(user.errors.full_messages.last).to include 'atleast one lower case character'
      end
    end

    context 'upper letter case' do
      let(:user) { build(:user, :without_atleast_one_upper_letter_password) }

      it 'user without one upper letter password shouldnt be saved' do
        expect(user).not_to be_valid
        expect(user.errors.full_messages.last).to include 'atleast one upper case character'
      end
    end

    context 'repeats' do
      let(:user) { build(:user, :with_repeating_chars_password) }

      it 'user with repeated password chars shouldnt be saved' do
        expect(user).not_to be_valid
        expect(user.errors.full_messages.last).to include 'duplicate characters'
      end
    end
  end
end
