defmodule JobbitExamples.QueryParamsScrubber do
  @moduledoc """

  A exhibition of the value of using `Jobbit`.

  The following submodules are implementations of a parser for a query params
  string with or without the leading `?` where for any pair all keys are allowed,
  but the input values are limited to `"1"` and `"2"`. Each parser must return,
  either a list of `{String.t(), :one | :two}`, or raise an error, or the
  afformentioned list wrapped in an 2 sized ok-tuple, or 2 sized error-tuple.

  Expectations for return values are based on the "will crash?" bullet in the
  moduledocs of each implementation. If the "will crash?" is "Yes" then
  successful parsing results in a list of values. If the "will crash?" is "No"
  then the implementation is expected to return the same list wrapped in an
  ok-tuple or in the case of failure returns an error-tuple. Any other behavior
  or outcome for the implementations is a bug on my part.

    + will_crash? - answers the question: "Given input of any type or value
      (within reason) will this code crash?"

    + effective lines of code - the count of lines of code including the `def`
      and `end` of code blocks because functions have clause that can logically
      branch in Elixir/Erlang.

    + time spent coding - the time from `def parse(str)` being able to compile,
      load, and run the happy path AND some non-happy-path cases without
      unexpected results.

    + level of effort - is completely subjective. However, the stress that was
      experienced in coding the `Declaratively` first (easy, quick, and simple)
      *THEN* coding the `Defensively` (less easy, more code, a little convoluted)
      and knowing that the solution "could be so simple" almost certainly
      caused my cortisol levels to rise. Though, *actual* science is needed to
      substantiate this claim.

    + optimized for fewer LOC? - answers the question: "Was extra time and
      effort spent reducing the effective lines of code?"I did not want the
      perception that I made decisions to make the `Defensively` example more
      complex than it needed to be so I decided to go over `Defensively`
      attempting to reduce its LOC. I took considerable effort to present the
      `Defensively` code example and its stats a fair and balance manner. As
      such, I spent some extra time reducing the LOC of `Defensively`. However,
      the "refactor" did not help `Defensively`'s case. I feel the effort to
      reduce the LOC is exactly the type of thing that is a trap, and may appear
      to make code better, but in reality has cost all of us (me, you, our
      company, our world) precious time.

    + easy-of-understanding - is a subjective measure of how long and how
      difficult a piece of code takes to understand. This measure include how
      much effort is spent deciding what the code was meant to do, what the code
      *actually* does in the most obvious cases, and as well as an estimation of
      how many ways a piece of code can do something unexpected.
  """

  defmodule Defensively do
    @moduledoc """
    Defensive code that must detect and protect itself from
    *every* invalid condition that a string could end up in.

    Note: I did not include the `DRYing` in the "effective LOC before"
    because it *should* have been done during the initial coding. I was mob
    coding for the initial pass. I was concerned I was taking too long and
    boring my audience so I chose to copy + paste my list-to-ok logic. This
    copy + paste ended up being a mistake 3 times over. 1) I ended up having
    to DRY up the code into a single function anyway. 2) It increased the
    initial code size. 3) The original code that was copied + pasted had a
    bug which means that after the paste I now had duplicated code with the
    same exact bug. The lesson? stick to best practices so you don't pay the
    price (repeatedly).

      + will_crash? - No

      + effective lines of code - 38

      + time spent coding - ~12min (bugs and mispellings abound) + ~5min for DRYing
        and LOC reduction

      + level of effort - Moderate

      + optimized for fewer LOC? - Yes - effective LOC before: 14 + 1 + 6 + 10 + 10

      + easy-of-understanding - Moderate
    """

    # 12 lines
    # (remove parens around for the `with` clauses that I love so much (-2 lines))
    def parse(str) when is_binary(str) do
      pair_strings =
        str
        |> String.trim_leading("?")
        |> String.split("&")

      with {:ok, pairs} <- to_kvs(pair_strings),
           {:ok, atomized} <- atomize_pairs(pairs) do
        {:ok, atomized}
      else
        _ -> :error
      end
    end

    # 1 line (needed so parse/1 wont crash)
    def parse(_non_string), do: :error

    # 3 lines
    # (changed from `case` (-3 lines) to multi-headed function clause)
    defp atomize({key, "1"}), do: {:ok, {key, :one}}
    defp atomize({key, "2"}), do: {:ok, {key, :two}}
    defp atomize({key, bad}), do: {:error, {:bad_value, bad, [key: key]}}

    # 10 lines
    # (DRYed `case` (-4 lines) to `list_is_ok/1`)
    defp atomize_pairs(pairs) do
      pairs
      |> Enum.reduce_while([], fn {key, val}, acc ->
        case atomize({key, val}) do
          {:ok, {key, atom}} -> {:cont, [{key, atom} | acc]}
          {:error, _} -> {:halt, :error}
        end
      end)
      |> list_is_ok()
    end

    # 10 lines
    # (DRYed `case` (-4 lines) to `list_is_ok/1`)
    defp to_kvs(pairs_strings) do
      pairs_strings
      |> Enum.reduce_while([], fn str, acc ->
        case String.split(str, "=") do
          [k, v] -> {:cont, [{k, v} | acc]}
          _ -> {:halt, :error}
        end
      end)
      |> list_is_ok()
    end

    # 2 lines
    # (DRYed up helper for list reducers +6 lines)
    # (DRYing resulted in -2 lines net - 8 removed from DRYing - 6 added in new list_is_ok/1)
    # (changed from `case` (-4 lines) to multi-headed function clause)
    defp list_is_ok(list) when is_list(list), do: {:ok, list}
    defp list_is_ok(:error), do: :error
  end

  defmodule Declaratively do
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

  defmodule WithJobbit do
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
    def parse(str) do
      fn -> Declaratively.parse(str) end
      |> Jobbit.async()
      |> Jobbit.yield()
    end
  end
end
