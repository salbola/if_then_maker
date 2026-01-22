require "rails_helper"
RSpec.describe Warnings::StatusTooManyActiveChecker, type: :model do
  let!(:user) { create(:user) }
  let(:memo) { create(:memo, user: user) }

  describe "checkするべきでない状況の確認" do
    context "すでにactiveが3つある状況" do
      before do
        create_list(
          :if_then_rule,
          3,
          user: user,
          memo: memo,
          status: :active
        )
      end

      context "新規作成時（current_rule が nil）" do
        it "status が active でなければ check をスキップして空配列を返す" do
          warnings = described_class.check(
            user: user,
            status: :draft
          )

          expect(warnings).to eq([])
        end
      end

      context "編集時（current_rule が存在する）" do
        let(:current_rule) do
          create(
            :if_then_rule,
            user: user,
            memo: memo,
            status: :active
          )
        end

        it "current_rule の status が active の場合は check をスキップする" do
          warnings = described_class.check(
            user: user,
            current_rule: current_rule,
            status: :active
          )

          expect(warnings).to eq([])
        end
      end
    end
  end

  describe ".check" do
    context "すでにactiveが3つある状況" do
      before do
        create_list(
          :if_then_rule,
          3,
          user: user,
          memo: memo,
          status: :active
        )
      end

      it "さらに active を追加しようとすると warning を返す" do
        warnings = described_class.check(
          user: user,
          status: "active"
        )

        puts "!!!!!!!!"
        p warnings
        expect(warnings).not_to be_empty
        expect(warnings.first[:concept]).to eq(:status_too_many_active)
      end
    end

    context "まだactiveが3つ未満の状況" do
      before do
        create_list(
          :if_then_rule,
          2,
          user: user,
          memo: memo,
          status: :active
        )
      end

      it "active を追加しようとしても warning は返らない" do
        warnings = described_class.check(
          user: user,
          status: :active
        )

        expect(warnings).to eq([])
      end
    end
  end



end
