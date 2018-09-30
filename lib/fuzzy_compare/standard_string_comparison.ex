defmodule FuzzyCompare.StandardStringComparison do
  @moduledoc """
  This module just wraps the `String.jaro_distance/2` function but it allows
  us to use a different comparison function in the future should the need ever
  arise.
  """
  @spec similarity(binary(), binary()) :: float()
  def similarity(left, right) when is_binary(left) and is_binary(right) do
    String.jaro_distance(left, right)
  end
end
