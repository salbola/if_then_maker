require "rails_helper"
RSpec.describe WarningConcepts::ThenNonVerifiableAction do
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
      it "patterns に mental_action を持つ" do
        expect(concept[:patterns]).to have_key(:mental_action)
      end
      it "patterns に attitude_action を持つ" do
        expect(concept[:patterns]).to have_key(:attitude_action)
      end
    end


    describe "patternsの各階層:mental_actionの中に関して" do
      it "mental_action は必要な属性を持つ" do
        pattern = concept[:patterns][:mental_action]

        expect(pattern).to include(
          :matchers,
          :reason,
          :suggestion,
          :example
        )
      end
    end
    describe "patternsの各階層:attitude_actionの中に関して" do
      it "attitude_action は必要な属性を持つ" do
        pattern = concept[:patterns][:attitude_action]

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
