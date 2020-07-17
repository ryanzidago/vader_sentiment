defmodule VaderSentimentTest do
  use ExUnit.Case
  doctest VaderSentiment

  describe "negated/2" do
    test "detects words in @negate" do
      assert VaderSentiment.negated(["cant", "do", "that"], false)
    end

    test "detect n't negation form" do
      assert VaderSentiment.negated(["can't", "do", "that"], true)
    end

    test "returns `false` if not words is a form of negation" do
      refute VaderSentiment.negated(["hello", "world"], true)
    end
  end

  describe "allcap_differential/1" do
    test "returns `true` if a word is upcased while another is downcased" do
      assert VaderSentiment.allcap_differential(["Biking", "is", "AWESOME"])
    end

    test "returns `false` if all words are downcased" do
      refute VaderSentiment.allcap_differential(["eat", "your", "vegetables"])
    end

    test "returns `false` if all words are upcased" do
      refute VaderSentiment.allcap_differential(["WORK", "HARD"])
    end
  end
end
