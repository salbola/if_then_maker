require "rails_helper"

RSpec.describe UserPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }


  subject { described_class }

  context "ログインしている場合" do
    permissions :edit?, :update? do
      it "本人なら認可OK" do
        expect(subject).to permit(user, user)
      end

      it "他人なら認可NG" do
        expect(subject).not_to permit(user, other_user)
      end
    end
  end

  context "ログインしていない場合" do
    permissions :new?, :create? do
      it "認可OK(ユーザーの新規作成)" do
        expect(subject).to permit(nil, User.new)
      end
    end

    permissions :edit?, :update? do
      it "認可NG" do
        expect(subject).not_to permit(nil, user)
      end
    end
  end

  describe "Scope" do
    it "ログインユーザー自身のみ返す" do
      resolved_scope = described_class::Scope.new(user, User).resolve

      expect(resolved_scope).to contain_exactly(user)
    end

    it "未ログインの場合は空を返す" do
      resolved_scope = described_class::Scope.new(nil, User).resolve

      expect(resolved_scope).to be_empty
    end
  end
end
