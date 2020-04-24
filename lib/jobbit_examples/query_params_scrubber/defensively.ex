defmodule JobbitExamples.QueryParamsScrubber.Defensively do
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
