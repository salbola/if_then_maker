require "rails_helper"
RSpec.describe WarningConcepts::ThenMissingEnvironmentAnchor do
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
      it "patterns に missing_environment_anchor を持つ" do
        expect(concept[:patterns]).to have_key(:missing_environment_anchor)
      end
    end


    describe "patternsの各階層:missing_environment_anchorの中に関して" do
      it "missing_environment_anchor は必要な属性を持つ" do
        pattern = concept[:patterns][:missing_environment_anchor]

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
