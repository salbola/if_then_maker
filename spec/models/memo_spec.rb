require "rails_helper"

RSpec.describe Memo, type: :model do
  describe "バリデーション" do
    let(:user) { User.create }

    it "title があれば有効" do
      memo = build(:memo, title: "テストメモ", user: user)
      expect(memo).to be_valid
    end

    it "title が空だと無効" do
      memo = build(:memo, title: nil, user: user)
      expect(memo).not_to be_valid
      expect(memo.errors[:title]).to include("can't be blank")
    end

    it "title が100文字を超えると無効" do
      memo = build(:memo, title: "a" * 101, user: user)
      expect(memo).not_to be_valid
    end
  end
end
