defmodule FuzzyCompare.ChunkSet do
  @moduledoc """
  For strings which among shared words also contain many dissimilar words the
  ChunkSet is ideal.

  It works in the following way:

  Our input strings are

    * `"oscar claude monet"`
    * `"alice hoschedé was the wife of claude monet"`

  From the input string three strings are created.
    * `common_words = "claude monet"`
    * `common_words_plus_remaining_words_left = "claude monet oscar"`
    * `common_words_plus_remaining_words_right = "claude monet alice hoschedé was the wife of"`

  These are then all compared with each other in pairs and the maximum ratio
  is returned.

  ## Examples

      iex> FuzzyCompare.ChunkSet.standard_similarity("oscar claude monet", "alice hoschedé was the wife of claude monet")
      0.8958333333333334

      iex> FuzzyCompare.ChunkSet.substring_similarity("oscar claude monet", "alice hoschedé was the wife of claude monet")
      1.0
  """
  alias FuzzyCompare.{
    Preprocessed,
    Preprocessor,
    StandardStringComparison,
    SubstringComparison
  }

  @spec standard_similarity(binary() | Preprocessed.t(), binary() | Preprocessed.t()) :: float()
  def standard_similarity(left, right) when is_binary(left) and is_binary(right) do
    {processed_left, processed_right} = Preprocessor.process(left, right)
    standard_similarity(processed_left, processed_right)
  end

  def standard_similarity(%Preprocessed{set: left}, %Preprocessed{set: right}) do
    similarity(left, right, StandardStringComparison)
  end

  @spec substring_similarity(binary() | Preprocessed.t(), binary() | Preprocessed.t()) :: float()
  def substring_similarity(left, right) when is_binary(left) and is_binary(right) do
    {processed_left, processed_right} = Preprocessor.process(left, right)
    substring_similarity(processed_left, processed_right)
  end

  def substring_similarity(%Preprocessed{set: left}, %Preprocessed{set: right}) do
    similarity(left, right, SubstringComparison)
  end

  @spec similarity(
          MapSet.t(String.t()),
          MapSet.t(String.t()),
          StandardStringComparison | SubstringComparison
        ) :: float()
  defp similarity(left, right, ratio_mod) do
    {common_words, common_words_plus_remaining_words_left,
     common_words_plus_remaining_words_right} = set_operations(left, right)

    [
      0.0,
      ratio_mod.similarity(common_words, common_words_plus_remaining_words_left),
      ratio_mod.similarity(common_words, common_words_plus_remaining_words_right),
      ratio_mod.similarity(
        common_words_plus_remaining_words_left,
        common_words_plus_remaining_words_right
      )
    ]
    |> Enum.max()
  end

  @spec set_operations(MapSet.t(String.t()), MapSet.t(String.t())) ::
          {binary(), binary(), binary()}
  defp set_operations(left, right) do
    common_words = MapSet.intersection(left, right)

    common_words_string =
      common_words
      |> Enum.sort()
      |> Enum.join()

    [
      common_words_plus_remaining_words_left_string,
      common_words_plus_remaining_words_right_string
    ] =
      [left, right]
      |> Enum.map(fn x ->
        common_words_string <>
          (x
           |> MapSet.difference(common_words)
           |> Enum.sort()
           |> Enum.join())
      end)

    {common_words_string, common_words_plus_remaining_words_left_string,
     common_words_plus_remaining_words_right_string}
  end
end
