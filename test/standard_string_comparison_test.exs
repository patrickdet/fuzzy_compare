defmodule StandardStringComparisonTest do
  use ExUnit.Case

  @subject FuzzyCompare.StandardStringComparison

  doctest @subject

  test "ratio is Jaro-Winkler distance" do
    result = @subject.similarity("Foo bar baz", "foo bar")
    assert result == 0.8008658008658008
    assert result == String.jaro_distance("Foo bar baz", "foo bar")
  end
end
