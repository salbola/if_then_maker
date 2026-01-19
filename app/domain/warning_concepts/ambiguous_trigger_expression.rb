module WarningConcepts
  AMBIGUOUS_TRIGGER_EXPRESSION = {
    description: "実行条件が曖昧で、行動のきっかけとして再現性が低い状態です",
    hint: {text:""}
    patterns: {
      always_expression: {
        matchers: ["常に", "つねに"],
        reason: "『常に』は例外を含みやすく、実行条件として曖昧になりがちです。",
        suggestion: "具体的な状況や行動に置き換えてみましょう。",
        example: "例：「常に疲れたら」→「仕事から帰宅して椅子に座ったら」"
      }
    }
  }.freeze
end