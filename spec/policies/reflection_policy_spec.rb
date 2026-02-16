require "rails_helper"

RSpec.describe ReflectionPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:rule) { create(:if_then_rule, user: user) }
  let(:other_rule) { create(:if_then_rule, user: other_user) }
  let!(:reflection) { create(:reflection, user: user,  if_then_rule: rule, reflected_on: Date.current) }
  let!(:other_reflection) { create(:reflection, user: other_user,  if_then_rule: other_rule, reflected_on: Date.current) }

  subject { described_class }

  context "ログインしている場合" do
    permissions :index?, :create? do
      it "allows access" do
        expect(subject).to permit(user, reflection)
      end
    end

    permissions :destroy? do
      it "所有者なら認可OK" do
        expect(subject).to permit(user, reflection)
      end

      it "所有していなければ認可NG" do
        expect(subject).not_to permit(user, other_reflection)
      end
    end
  end

  context "ログインしていない場合" do
    permissions :index?, :create?, :destroy? do
      it "認可NG" do
        expect(subject).not_to permit(nil, reflection)
      end
    end
  end

  describe "Scope" do
    it "そのユーザの所有してるreflectionのみ返す" do
      reflection
      other_reflection

      resolved_scope = described_class::Scope.new(user, Reflection).resolve

      expect(resolved_scope).to contain_exactly(reflection)
      expect(resolved_scope).not_to include(other_reflection)
    end
  end
end
