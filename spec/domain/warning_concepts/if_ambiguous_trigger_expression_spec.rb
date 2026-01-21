require "rails_helper"
RSpec.describe WarningConcepts::IfAmbiguousTriggerExpression do
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
      it "patterns に never_come_time_expression:を持つ" do
        expect(concept[:patterns]).to have_key(:never_come_time_expression)
      end
      it "patterns に only_vague_time_expression:を持つ" do
        expect(concept[:patterns]).to have_key(:only_vague_time_expression)
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
    describe "patternsの各階層:never_come_time_expressionの中に関して" do
      it "never_come_time_expression は必要な属性を持つ" do
        pattern = concept[:patterns][:never_come_time_expression]

        expect(pattern).to include(
          :matchers,
          :reason,
          :suggestion,
          :example
        )
      end
    end
    describe "patternsの各階層:only_vague_time_expressionの中に関して" do
      it "only_vague_time_expression は必要な属性を持つ" do
        pattern = concept[:patterns][:only_vague_time_expression]

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
