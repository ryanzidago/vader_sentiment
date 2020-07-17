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

  describe "scalar_inc_dec/3" do
    # random examples obtanained by calling the scalar_inc_dec function from the Python library
    # => 0.293 # scalar_inc_dec("absolutely", 0.8, True)
    # => -0.293 # scalar_inc_dec("slightly", 0.6, False)
    # => 0.0 # scalar_inc_dec("great", 0.0, True)
    test "increases or decreases the scalar score for words contained in @booster_dict; while obtaining the same results as the original Python library" do
      assert 0.293 == VaderSentiment.scalar_inc_dec("absolutely", 0.8, true)
      assert -0.293 == VaderSentiment.scalar_inc_dec("slightly", 0.6, false)
    end

    test "returns `0` for words not in @booster_dict; while obtaining the same results as the original Python library" do
      assert 0 == VaderSentiment.scalar_inc_dec("great", 0.9, true)
    end
  end
end
