require "rails_helper"
RSpec.describe WarningConcepts::IfUnobservableTrigger do
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
      it "patterns に emotional_state_trigger を持つ" do
        expect(concept[:patterns]).to have_key(:emotional_state_trigger)
      end
      it "patterns に subjective_state_condition を持つ" do
        expect(concept[:patterns]).to have_key(:subjective_state_condition)
      end
    end


    describe "patternsの各階層:emotional_state_triggerの中に関して" do
      it "emotional_state_trigger は必要な属性を持つ" do
        pattern = concept[:patterns][:emotional_state_trigger]

        expect(pattern).to include(
          :matchers,
          :reason,
          :suggestion,
          :example
        )
      end
    end
    describe "patternsの各階層:subjective_state_conditionの中に関して" do
      it "subjective_state_condition は必要な属性を持つ" do
        pattern = concept[:patterns][:subjective_state_condition]

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
