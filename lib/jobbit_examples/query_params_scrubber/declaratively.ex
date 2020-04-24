defmodule JobbitExamples.QueryParamsScrubber.Declaratively do
  @moduledoc """
  Declarative code that either successfully parses
  our query params correctly, or raises.

    + will_crash? - Yes

    + effective lines of code - 11

    + time coding - ~2min

    + level of effort - Very Low

    + optimized for fewer LOC? - No

    + easy-of-understanding - Very High
  """
  def parse(str) do
    str
    |> String.trim_leading("?")
    |> String.split("&")
    |> Enum.map(fn pair ->
      case String.split(pair, "=") do
        [key, "1"] -> {key, :one}
        [key, "2"] -> {key, :two}
      end
    end)
  end
end
