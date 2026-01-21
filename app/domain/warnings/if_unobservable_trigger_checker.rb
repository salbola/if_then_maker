module Warnings
  class IfUnobservableTriggerChecker
    CONCEPT = WarningConcepts::IfUnobservableTriggerChecker
    def self.check(text)
        return [] if text.blank?

        warnings = []

        concept_key = CONCEPT.concept_key
        concept = CONCEPT.definition

        concept[:patterns].each do |pattern_key, pattern|
          matched = pattern[:matchers].select { |w| text.include?(w) }
          next if matched.empty?

          warnings << {
            field: :if_condition,
            concept: concept_key,
            pattern: pattern_key,
            matches: matched
          }
        end

        warnings
      end
  end
end
