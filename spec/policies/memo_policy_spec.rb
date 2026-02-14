require "rails_helper"

RSpec.describe MemoPolicy do
  subject { described_class }

  let(:owner) { create(:user) }
  let(:other_user) { create(:user) }
  let(:memo) { create(:memo, user: owner) }

  permissions :show?, :update?, :destroy? do
    it "allows owner" do
      expect(subject).to permit(owner, memo)
    end

    it "denies other users" do
      expect(subject).not_to permit(other_user, memo)
    end
  end

  permissions :create? do
    it "allows logged in user" do
      expect(subject).to permit(owner, Memo.new(user: owner))
    end
  end
end