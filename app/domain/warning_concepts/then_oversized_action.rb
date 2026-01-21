module WarningConcepts
  # zeit werkがキャメルケースで予測するらしいので全文字が大文字になる定数でなくキャメルケースになるクラスを使用することにした
  class ThenOversizedAction
    def self.concept_key
      name.demodulize.underscore.to_sym
    end

    def self.definition
      {
        label: "完了を判別できる行動",
        description: "迷わず最初の一歩を始められるサイズになっている(スモールステップ,ベビーステップ,5ルールのような)行動",
        hint: "迷わず最初の一歩を始められるサイズになっている",
        patterns: {
          too_large_action: {
            matchers: [
            "おわらせる"
            ],
            reason: "頭の中で完結する動作で習慣として機能しないかもしれません。",
            suggestion: "書く・声に出す・物を動かすなど、外から確認できる行動にしてみましょう。",
            example: "例：「今日することを考える」→「今日することをノートに書き出す」"
          },
          multi_step_action: {
            matchers: [
              "してから","それから","したら","してから",
              "そしたら","後","あと","しながら","やりながら","しつつ","やりつつ","ながら",
              "一緒","いっしょ","と共に","とともに","同時に","どうじに"

            ],
            reason: "心構えや姿勢は達成条件がなく、完了を判別できません。",
            suggestion: "書く・声に出す・物を動かすなど、外から確認できる行動にしてみましょう。",
            example: "例：「集中して頑張る」→「タイマーを5分セットして1問解く」"
          }

        }
      }
    end
  end
end
