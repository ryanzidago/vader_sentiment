defmodule VaderSentiment do
  @moduledoc """
  Documentation for `VaderSentiment`.
  """

  @b_incr 0.293
  @b_decr -0.293

  @c_incr 0.733
  @n_scalar -0.74

  @negate [
    "aint",
    "arent",
    "cannot",
    "cant",
    "couldnt",
    "darent",
    "didnt",
    "doesnt",
    "ain't",
    "aren't",
    "can't",
    "couldn't",
    "daren't",
    "didn't",
    "doesn't",
    "dont",
    "hadnt",
    "hasnt",
    "havent",
    "isnt",
    "mightnt",
    "mustnt",
    "neither",
    "don't",
    "hadn't",
    "hasn't",
    "haven't",
    "isn't",
    "mightn't",
    "mustn't",
    "neednt",
    "needn't",
    "never",
    "none",
    "nope",
    "nor",
    "not",
    "nothing",
    "nowhere",
    "oughtnt",
    "shant",
    "shouldnt",
    "uhuh",
    "wasnt",
    "werent",
    "oughtn't",
    "shan't",
    "shouldn't",
    "uh-uh",
    "wasn't",
    "weren't",
    "without",
    "wont",
    "wouldnt",
    "won't",
    "wouldn't",
    "rarely",
    "seldom",
    "despite"
  ]

  @booster_dict %{
    "absolutely" => @b_incr,
    "amazingly" => @b_incr,
    "awfully" => @b_incr,
    "completely" => @b_incr,
    "considerable" => @b_incr,
    "considerably" => @b_incr,
    "decidedly" => @b_incr,
    "deeply" => @b_incr,
    "effing" => @b_incr,
    "enormous" => @b_incr,
    "enormously" => @b_incr,
    "entirely" => @b_incr,
    "especially" => @b_incr,
    "exceptional" => @b_incr,
    "exceptionally" => @b_incr,
    "extreme" => @b_incr,
    "extremely" => @b_incr,
    "fabulously" => @b_incr,
    "flipping" => @b_incr,
    "flippin" => @b_incr,
    "frackin" => @b_incr,
    "fracking" => @b_incr,
    "fricking" => @b_incr,
    "frickin" => @b_incr,
    "frigging" => @b_incr,
    "friggin" => @b_incr,
    "fully" => @b_incr,
    "fuckin" => @b_incr,
    "fucking" => @b_incr,
    "fuggin" => @b_incr,
    "fugging" => @b_incr,
    "greatly" => @b_incr,
    "hella" => @b_incr,
    "highly" => @b_incr,
    "hugely" => @b_incr,
    "incredible" => @b_incr,
    "incredibly" => @b_incr,
    "intensely" => @b_incr,
    "major" => @b_incr,
    "majorly" => @b_incr,
    "more" => @b_incr,
    "most" => @b_incr,
    "particularly" => @b_incr,
    "purely" => @b_incr,
    "quite" => @b_incr,
    "really" => @b_incr,
    "remarkably" => @b_incr,
    "so" => @b_incr,
    "substantially" => @b_incr,
    "thoroughly" => @b_incr,
    "total" => @b_incr,
    "totally" => @b_incr,
    "tremendous" => @b_incr,
    "tremendously" => @b_incr,
    "uber" => @b_incr,
    "unbelievably" => @b_incr,
    "unusually" => @b_incr,
    "utter" => @b_incr,
    "utterly" => @b_incr,
    "very" => @b_incr,
    "almost" => @b_decr,
    "barely" => @b_decr,
    "hardly" => @b_decr,
    "just enough" => @b_decr,
    "kind of" => @b_decr,
    "kinda" => @b_decr,
    "kindof" => @b_decr,
    "kind-of" => @b_decr,
    "less" => @b_decr,
    "little" => @b_decr,
    "marginal" => @b_decr,
    "marginally" => @b_decr,
    "occasional" => @b_decr,
    "occasionally" => @b_decr,
    "partly" => @b_decr,
    "scarce" => @b_decr,
    "scarcely" => @b_decr,
    "slight" => @b_decr,
    "slightly" => @b_decr,
    "somewhat" => @b_decr,
    "sort of" => @b_decr,
    "sorta" => @b_decr,
    "sortof" => @b_decr,
    "sort-of" => @b_decr
  }

  @sentiment_laden_idioms %{
    "cut the mustard" => 2,
    "hand to mouth" => -2,
    "back handed" => -2,
    "blow smoke" => -2,
    "blowing smoke" => -2,
    "upper hand" => 1,
    "break a leg" => 2,
    "cooking with gas" => 2,
    "in the black" => 2,
    "in the red" => -2,
    "on the ball" => 2,
    "under the weather" => -2
  }

  @special_cases %{
    "the shit" => 3,
    "the bomb" => 3,
    "bad ass" => 1.5,
    "badass" => 1.5,
    "bus stop" => 0.0,
    "yeah right" => -2,
    "kiss of death" => -1.5,
    "to die for" => 3,
    "beating heart" => 3.1,
    "broken heart" => -2.9
  }

  def negated(input_words, include_nt)

  def negated(input_words, true) do
    input_words = downcase_words(input_words)
    input_words_in_negate?(input_words) || input_words_contains_nt?(input_words)
  end

  def negated(input_words, false) do
    input_words
    |> downcase_words()
    |> input_words_in_negate?()
  end

  defp downcase_words(words) do
    Enum.map(words, &String.downcase/1)
  end

  defp input_words_in_negate?(input_words) do
    true in Enum.map(input_words, fn input_word -> input_word in @negate end)
  end

  defp input_words_contains_nt?(input_words) do
    true in Enum.map(input_words, fn input_word -> String.contains?(input_word, "n't") end)
  end

  def normalize(score, alpha \\ 15) do
    norm_score = score / :math.sqrt(score * score + alpha)

    cond do
      norm_score <= -1.0 -> -1.0
      norm_score >= 1.0 -> 1.0
      true -> norm_score
    end
  end

  def allcap_differential(words) do
    is_different = false

    allcap_words =
      words
      |> Enum.map(fn word -> if String.upcase(word) == word, do: 1, else: 0 end)
      |> Enum.sum()

    cap_differential = length(words) - allcap_words

    if 0 < cap_differential and cap_differential < length(words) do
      true
    else
      is_different
    end
  end

  @doc """
  -0.293 = scalar_inc_dec("fucking", -0.9, false)
  """
  def scalar_inc_dec(word, valence, is_cap_diff) do
    scalar = 0.0
    word_lower = String.downcase(word)

    case Map.has_key?(@booster_dict, word_lower) do
      true ->
        scalar = Map.get(@booster_dict, word_lower)
        scalar = if valence < 0, do: scalar * -1, else: scalar

        if String.upcase(word) == word and is_cap_diff do
          if valence > 0 do
            scalar + @c_incr
          else
            scalar - @c_incr
          end
        else
          scalar
        end

      false ->
        scalar
    end
  end

  defmodule SentiText do
    @punctuation ~r/[^a-z0-9 ]+/

    def is_cap_diff(text) do
      text
      |> words_and_emoticons()
      |> VaderSentiment.allcap_differential()
    end

    def strip_punc_if_word(token) do
      stripped_token = String.replace(token, @punctuation, "")

      if String.length(stripped_token) <= 2 do
        token
      else
        stripped_token
      end
    end

    def words_and_emoticons(text) do
      text
      |> String.split()
      |> Stream.map(&strip_punc_if_word/1)
      |> Enum.to_list()
    end
  end

  defmodule SentimentIntensityAnalyzer do
    def lexicon_full_filepath do
      File.cwd!() <> "/lib/vader_lexicon.txt"
    end

    def emoji_full_path do
      File.cwd!() <> "/lib/emoji_utf8_lexicon.txt"
    end

    def make_lex_map do
      lexicon_full_filepath()
      |> parse_lexicon()
      |> do_make_lex_map()
    end

    defp parse_lexicon(path_to_lexicon) do
      path_to_lexicon
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "\t"))
    end

    defp do_make_lex_map(file) do
      for [token, measure, _, _] = _line <- file, into: %{}, do: {token, measure}
    end

    def make_emoji_map do
      emoji_full_path()
      |> parse_lexicon()
      |> do_make_emoji_map()
    end

    defp do_make_emoji_map(file) do
      for [emoji, description] = _line <- file, into: %{}, do: {emoji, description}
    end
  end
end
