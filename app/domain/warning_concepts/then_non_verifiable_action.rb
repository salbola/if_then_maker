module WarningConcepts
  # zeit werkがキャメルケースで予測するらしいので全文字が大文字になる定数でなくキャメルケースになるクラスを使用することにした
  class ThenNonVerifiableAction
    def self.concept_key
      name.demodulize.underscore.to_sym
    end

    def self.definition
      {
        label: "完了を判別できる行動",
        description: "実行条件が曖昧で、行動のきっかけとして再現性が低い状態",
        hint: "終わったかどうかを自分で判断できる",
        patterns: {
          mental_action: {
            matchers: [ "考える", "かんがえる", "意識", "いしき", ],
            reason: "頭の中で完結するものなので習慣として機能しないかもしれません。",
            suggestion: "物理的な状況や行動に置き換えてみましょう。",
            example: "例：「今日することを考える」→「今日することをノートに書き出す」"
          },

          
        }
      }
    end
  end
end
