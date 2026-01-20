module Warnings
class WarningMessageBuilder
  def self.build(warning)
  # もし古い形式の構造など互換性のない形式のwarningが含まれていたらエラーを出す
  unless warning[:concept] || warning[:pattern] || warning[:matches]
    raise ArgumentError, "Unsupported warning format: #{warning.inspect}"
  end
    concept_name = warning[:concept].to_s.camelize
    concept_class = "WarningConcepts::#{concept_name}".safe_constantize
    return nil unless concept_class

    definition = concept_class.definition
    pattern = definition[:patterns][warning[:pattern]]
    return nil unless pattern

    matched = warning[:matches].uniq.join("、")

    {
      field: warning[:field],
      reason: "「#{matched}」は#{pattern[:reason]}",
      suggestion: pattern[:suggestion],
      example: pattern[:example]
    }
  end
end
end
