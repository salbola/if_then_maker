module WarningConcepts
  # zeit werkがキャメルケースで予測するらしいので全文字が大文字になる定数でなくキャメルケースになるクラスを使用することにした
  class ThenMissingEnvironmentAnchor
    def self.concept_key
      name.demodulize.underscore.to_sym
    end

    def self.definition
      {
        label: "現実の環境と結びついた行動",
        description: "現実の環境と結びついた行動で実行難易度を下げる",
        hint: "具体的な場所や道具が思い浮かぶ",
        patterns: {
          missing_environment_anchor: {
            matchers: [
            ""# 自動検知はしない前提なので matcher は空 or ダミー
            ],
            reason: "行動が抽象的だと、実行する瞬間に『どこで・何を使ってやるか』を考える必要があり、行動開始のハードルが上がります。",
            suggestion: "行動を、特定の場所や道具と結びつけて表現してみましょう。『どこで』『何を使って』が自然に浮かぶ形にすると、実行しやすくなります。",
            example: "例：「ストレッチする」→「寝室で、ヨガマットを敷いて1分ストレッチする」"
          },

        }
      }
    end
  end
end
