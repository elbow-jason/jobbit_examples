defmodule Jobbit.QueryParamsScrubberTest do
  use ExUnit.Case

  alias JobbitExamples.QueryParamsScrubber.Declaratively
  alias JobbitExamples.QueryParamsScrubber.Defensively
  alias JobbitExamples.QueryParamsScrubber.WithJobbit
  alias Jobbit.TaskError

  @good_string "?jason=1&adam=2&mike=1&zach=2&xn=1"
  @bad_value_in_a_pair @good_string <> "&other=not_one_nor_two"
  @bad_formats [
    "?jason=1&&&&&adam=2",
    "?jason==1&adam=2",
    "?jason1&adam=2",
    "abc123",
    "?jason=1&adam=2?&mike=1",
  ]

  @non_string 1.1

  @success_list [
    {"jason", :one},
    {"adam", :two},
    {"mike", :one},
    {"zach", :two},
    {"xn", :one},
  ]

  describe "Declaratively" do
    test "works for valid rule-matching query params string" do
      assert Declaratively.parse(@good_string) == @success_list
    end

    test "crashes for bad value in one of the pairs" do
      assert_raise(CaseClauseError, fn -> Declaratively.parse(@bad_value_in_a_pair) end)
    end

    test "crashes for invalid formats" do
      Enum.each(@bad_formats, fn bad_format ->
        assert_raise(CaseClauseError, fn -> Declaratively.parse(bad_format) end)
      end)
    end

    test "crashes for non-string" do
      assert_raise(FunctionClauseError, fn -> Declaratively.parse(@non_string) end)
    end
  end

  describe "Defensively" do
    test "works for valid rule-matching query params string" do
      assert Defensively.parse(@good_string) == {:ok, @success_list}
    end

    test "errors for bad value in one of the pairs" do
      assert :error = Defensively.parse(@bad_value_in_a_pair)
    end

    test "errors for invalid formats" do
      Enum.each(@bad_formats, fn bad_format ->
        assert :error = Defensively.parse(bad_format)
      end)
    end

    test "errors for non-string" do
      assert :error = Defensively.parse(@non_string)
    end
  end

  describe "WithJobbit" do
    test "works for valid rule-matching query params string" do
      assert WithJobbit.parse(@good_string) == {:ok, @success_list}
    end

    test "errors for bad value in one of the pairs" do
      assert {:error, %TaskError{}} = WithJobbit.parse(@bad_value_in_a_pair)
    end

    test "errors for invalid formats" do
      Enum.each(@bad_formats, fn bad_format ->
        assert {:error, %TaskError{}} = WithJobbit.parse(bad_format)
      end)
    end

    test "errors for non-string" do
      assert {:error, %TaskError{}} = WithJobbit.parse(@non_string)
    end
  end
end
