module Warnings
  class IfDuplicateContentChecker
    CONCEPT = WarningConcepts::IfDuplicateContent
    def self.check(user:, if_condition:, exclude_id: nil)
      return [] if if_condition.blank?
      

      concept_key = CONCEPT.concept_key
      concept = CONCEPT.definition
      pattern_key = concept[:patterns].keys.first
      pattern = concept[:patterns][pattern_key]

      scope = user.if_then_rules.where(if_condition: if_condition)
      # 無視するべきIDを取り除く
      scope = scope.where.not(id: exclude_id) if exclude_id

      if scope.exists?
        [ {
            field: :if_condition,
            concept: concept_key,
            pattern: pattern_key,
            matches: [],
            metadata: {}

        } ]
      else
        []
      end
    end
  end
end
