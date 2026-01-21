module Warnings
  class IfUnobservableTriggerChecker
    def self.check(text)
        return [] if text.blank?

        warnings = []

        concept_key = :if_unobservable_trigger
        concept = WarningConcepts::IfUnobservableTriggerChecker.definition

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
