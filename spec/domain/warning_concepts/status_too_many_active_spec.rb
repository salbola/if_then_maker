require "rails_helper"
RSpec.describe WarningConcepts::StatusTooManyActive do
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
      it "patterns に too_many_active を持つ" do
        expect(concept[:patterns]).to have_key(:too_many_active)
      end
    end


    describe "patternsの各階層:too_many_activeの中に関して" do
      it "too_many_active は必要な属性を持つ" do
        pattern = concept[:patterns][:too_many_active]

        expect(pattern).to include(
          :matchers,
          :reason,
          :suggestion,
          :example,
        )
      end
    end
  end
end
