require "rails_helper"
RSpec.describe WarningConcepts::ThenNegativeExpressionAction do
  describe ".definition" do
    let(:concept) { described_class.definition }
    describe "一番上の構成に関して" do
      it "conceptとして必要なキーを持つ" do
      expect(concept).to include(
        :label,
        :description,
        :hint,
        :patterns
      )
      end
    end


    describe "patterns階層に関して" do
      it "patterns に negative_expression_action を持つ" do
        expect(concept[:patterns]).to have_key(:negative_expression_action)
      end
    end


    describe "patternsの各階層:negative_expression_actionの中に関して" do
      it "negative_expression_action は必要な属性を持つ" do
        pattern = concept[:patterns][:negative_expression_action]

        expect(pattern).to include(
          :matchers,
          :reason,
          :suggestion,
          :example
        )
      end
    end
  end
end
