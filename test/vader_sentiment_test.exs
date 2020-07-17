defmodule VaderSentimentTest do
  use ExUnit.Case
  doctest VaderSentiment

  test "greets the world" do
    assert VaderSentiment.hello() == :world
  end
end
