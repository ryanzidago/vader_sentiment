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
end
