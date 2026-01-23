module WarningConcepts
  # zeit werkがキャメルケースで予測するらしいので全文字が大文字になる定数でなくキャメルケースになるクラスを使用することにした
  class StatusTooManyActive
    LIMIT = 3
    def self.concept_key
      name.demodulize.underscore.to_sym
    end

    def self.definition
      {
        label: "実行中のルールが多いことによる挫折を防ぐ",
        target: :status,
        description: "実行中のルールが多すぎると実行できなくなって挫折する",
        hint: "実行中のルールが可能な数に収まっている ",
        patterns: {
          too_many_active: {
            matchers: [ "" ],
            reason: "実行中のルールが少し多いかもしれません。",
            suggestion: "一度に実行する数は#{LIMIT}つまでを推奨しています。ひとまずは焦らず下書きにしておいて,優先度で順番にしましょう。",
            example: "例：1ヶ月の間で週に4回以上実行できたら一つ習慣化済にしてから次のルールを実行中にするなど"
          }

        }
      }
    end
  end
end
