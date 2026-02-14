require "rails_helper"

RSpec.describe DashBoardPolicy, type: :policy do
  let(:user) { create(:user) }
  # let(:other_user) { create(:user) }

  subject { described_class }

  context "ログインしている場合" do
    permissions :index? do
      it "認可OK" do
        expect(subject).to permit(user)
      end
    end
  end

  context "ログインしていない場合" do
    permissions :index? do
      it "認可NG" do
        expect(subject).not_to permit(nil)
      end
    end
  end
end