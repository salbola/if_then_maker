require "rails_helper"
RSpec.describe Warnings::WarningMessageBuilder do
  let(:warning) do
  {
    field: :if_condition,
    concept: :ambiguous_trigger_expression,
    pattern: :always_expression,
    matches: [ "常に" ]
  }
  end
  describe ".build" do
    it "表示用のwarning messageを構築する" do
      message = described_class.build(warning)

      expect(message).to include(
        :field,
        :reason,
        :suggestion,
        :example
      )
    end

    it "fieldを引き継ぐ" do
      message = described_class.build(warning)

      expect(message[:field]).to eq(:if_condition)
    end

    it "マッチしたワードがreasonに含められている" do
      message = described_class.build(warning)

      expect(message[:reason]).to include("常に")
    end
  end
end
