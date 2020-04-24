defmodule JobbitExamples.QueryParamsScrubber.WithJobbit do
  @moduledoc """
  We use Jobbit to protect ourselves from the "let it crash" code in
  `Declaratively`. This results in non-crashing code that is easy to
  understand, has fewer logical branches, more efficient (not a lot of list
  building and traversal in `Declaratively`), has fewer bugs (by both its
  fewer-lines-of-code nature AND in *actual* practice), and was drastically
  less time to complete.

    + will_crash? - Yes

    + effective lines of code - 16 (5 in WithJobbit + 11 in Declaratively)

    + time coding - ~11sec

    + level of effort - 3x Very Low

    + optimized for fewer LOC? - No

    + easy-of-understanding - Very High
  """

  alias JobbitExamples.QueryParamsScrubber.Declaratively

  def parse(str) do
    fn -> Declaratively.parse(str) end
    |> Jobbit.async()
    |> Jobbit.yield()
  end
end
