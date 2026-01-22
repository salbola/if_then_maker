require "rails_helper"
RSpec.describe WarningConcepts::IfDuplicateContent do
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
      it "patterns に duplicate_content を持つ" do
        expect(concept[:patterns]).to have_key(:duplicate_content)
      end
    end


    describe "patternsの各階層:duplicate_contentの中に関して" do
      it "duplicate_content は必要な属性を持つ" do
        pattern = concept[:patterns][:duplicate_content]

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
