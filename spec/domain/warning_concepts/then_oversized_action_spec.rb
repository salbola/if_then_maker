require "rails_helper"
RSpec.describe WarningConcepts::ThenOversizedAction do
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
      it "patterns に too_large_action を持つ" do
        expect(concept[:patterns]).to have_key(:too_large_action)
      end
      it "patterns に multi_step_action を持つ" do
        expect(concept[:patterns]).to have_key(:multi_step_action)
      end
    end


    describe "patternsの各階層:too_large_actionの中に関して" do
      it "too_large_action は必要な属性を持つ" do
        pattern = concept[:patterns][:too_large_action]

        expect(pattern).to include(
          :matchers,
          :reason,
          :suggestion,
          :example
        )
      end
    end
    describe "patternsの各階層:multi_step_actionの中に関して" do
      it "multi_step_action は必要な属性を持つ" do
        pattern = concept[:patterns][:multi_step_action]

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
