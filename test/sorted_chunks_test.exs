defmodule SortedChunksTest do
  use ExUnit.Case

  @subject FuzzyCompare.SortedChunks

  doctest @subject

  test "#standard_similarity" do
    assert @subject.standard_similarity("first second third", "second first third") == 1.0
  end
end
