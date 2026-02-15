require "rails_helper"

RSpec.describe MemoPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:memo) { create(:memo, user: user) }
  let(:other_memo) { create(:memo, user: other_user) }

  subject { described_class }

  context "ログインしている場合" do
    permissions :index?, :stale?, :new?, :create? do
      it "allows access" do
        expect(subject).to permit(user, memo)
      end
    end

    permissions :show?, :edit?, :update?, :destroy? do
      it "所有者なら認可OK" do
        expect(subject).to permit(user, memo)
      end

      it "所有していなければ認可NG" do
        expect(subject).not_to permit(user, other_memo)
      end
    end
  end

  context "ログインしていない場合" do
    permissions :index?, :stale?, :new?, :create?,
                :show?, :edit?, :update?, :destroy? do
      it "認可NG" do
        expect(subject).not_to permit(nil, memo)
      end
    end
  end

  describe "Scope" do
    it "そのユーザの所有してるメモのみ返す" do
      memo
      other_memo

      resolved_scope = described_class::Scope.new(user, Memo.all).resolve

      expect(resolved_scope).to contain_exactly(memo)
      expect(resolved_scope).not_to include(other_memo)
    end
  end
end
