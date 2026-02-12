require "rails_helper"

RSpec.describe Memo, type: :model do
  include ActiveSupport::Testing::TimeHelpers
  let(:user) { create(:user) }
  describe "バリデーション" do
    it "title があれば有効" do
      memo = build(:memo, title: "テストメモ", user: user)
      expect(memo).to be_valid
    end


    it "title が100文字を超えると無効" do
      memo = build(:memo, title: "a" * 101, user: user)
      expect(memo).not_to be_valid
    end
  end
  describe "#display_for_select" do
    it "titleとbodyを結合して表示する" do
      memo = build(:memo, title: "タイトル", body: "本文")

      expect(memo.display_for_select).to eq("タイトル - 本文")
    end

    it "titleがない場合は無題になる" do
      memo = build(:memo, title: nil, body: "本文")

      expect(memo.display_for_select).to start_with("（無題）")
    end

    it "bodyがnilでもエラーにならずハイフンだけ残る" do
      memo = build(:memo, title: "タイトル", body: nil)

      expect(memo.display_for_select).to end_with(" - ")
    end
  end

  describe ".stale" do
    subject { Memo.stale(days) }

    let(:days) { 7 }
    let(:user) { create(:user) }

    around do |example|
      freeze_time { example.run }
    end

    context "取得される場合(7日よりupdated_atが前かつルールを持たないもの)" do
      context "updated_atが8日前でルールがない場合" do
        let!(:memo) { create(:memo, user: user, updated_at: 8.days.ago) }
        it "取得されること" do
          expect(subject).to include(memo)
        end
      end

      context "updated_atがちょうど7日前でルールがない場合" do
        let!(:memo) { create(:memo, user: user, updated_at: 7.days.ago) }

        it "取得されること" do
          expect(subject).to include(memo)
        end
      end
    end
    context "取得されない場合(6日以内あるいはルールを持つ場合)" do
      context "updated_atが6日前の場合" do
        let!(:memo) { create(:memo, user: user, updated_at: 6.days.ago) }

        it "取得されないこと" do
          expect(subject).not_to include(memo)
        end
      end

      context "ルールが存在する場合" do
        let!(:memo) { create(:memo, user: user, updated_at: 10.days.ago) }

        before do
          create(:if_then_rule, memo: memo, user: user)
        end

        it "取得されないこと" do
          expect(subject).not_to include(memo)
        end
      end
    end

    context "日数を指定した場合" do
      context "30日指定の場合" do
        let(:days) { 30 }
        let!(:memo) { create(:memo, user: user, updated_at: 30.days.ago) }

        it "取得されること" do
          expect(subject).to include(memo)
        end
      end
    end
  end
end
