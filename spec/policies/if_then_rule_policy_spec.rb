require "rails_helper"

RSpec.describe IfThenRulePolicy, type: :policy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:if_then_rule) { create(:if_then_rule, user: user) }
  let(:other_if_then_rule) { create(:if_then_rule, user: other_user) }

  subject { described_class }

  context "ログインしている場合" do
    permissions :index?, :new?, :create? do
      it "allows access" do
        expect(subject).to permit(user, if_then_rule)
      end
    end

    permissions :show?, :edit?, :update?, :destroy? do
      it "所有者なら認可OK" do
        expect(subject).to permit(user, if_then_rule)
      end

      it "所有していなければ認可NG" do
        expect(subject).not_to permit(user, other_if_then_rule)
      end
    end
  end

  context "ログインしていない場合" do
    permissions :index?, :new?, :create?,
                :show?, :edit?, :update?, :destroy? do
      it "認可NG" do
        expect(subject).not_to permit(nil, if_then_rule)
      end
    end
  end

  describe "Scope" do
    it "そのユーザの所有してるIf-Thenルールのみ返す" do
      if_then_rule
      other_if_then_rule

      resolved_scope = described_class::Scope.new(user, IfThenRule.all).resolve

      expect(resolved_scope).to contain_exactly(if_then_rule)
      expect(resolved_scope).not_to include(other_if_then_rule)
    end
  end
end
