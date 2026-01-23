require "rails_helper"

RSpec.describe WarningConcepts do
  describe ".all" do
    subject(:all_concepts) { described_class.all }

    it "WarningConcepts配下のクラスを返す" do
      expect(all_concepts).to all(be_a(Class))
    end

    it "少なくとも1つ以上のコンセプトが存在する" do
      expect(all_concepts).not_to be_empty
    end
  end

  describe ".concepts_for" do
    subject(:if_concepts) { described_class.concepts_for(:if) }

    it ":if を target に持つコンセプトのみを返す" do
      expect(if_concepts).to all(
        satisfy { |c| c.definition[:target] == :if }
      )
    end
  end

  describe ".hints_for" do
    subject(:then_hints) { described_class.hints_for(:then) }

    it ":then かつ hint が enabled のコンセプトのみを返す" do
      expect(then_hints).to all(
        satisfy { |c| c.definition.dig(:hint, :enabled) }
      )
    end
  end
end
