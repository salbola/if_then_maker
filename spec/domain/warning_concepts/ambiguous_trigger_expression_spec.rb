require "rails_helper"
RSpec.describe WarningConcepts::AmbiguousTriggerExpression do
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
      it "patterns に always_expression を持つ" do
        expect(concept[:patterns]).to have_key(:always_expression)
      end
    end


    describe "patternsの各階層:always_expressionの中に関して" do
      it "always_expression は必要な属性を持つ" do
        pattern = concept[:patterns][:always_expression]

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
