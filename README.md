# FuzzyCompare

## Getting started

In order to compare two strings with each other do the following:

    iex> FuzzyCompare.similarity("Oscar-Claude Monet", "monet, claude")
    0.95

## Inner workings

Imagine you had to [match some names](https://en.wikipedia.org/wiki/Record_linkage).

Try to match the following list of painters:

  * `"Oscar-Claude Monet"`
  * `"Edouard Manet"`
  * `"Monet, Claude"`

For a human it is easy to see that some of the names have just been flipped
and that others are different but similar sounding.

A first approrach could be to compare the strings with a string similarity
function like the
[Jaro-Winkler](https://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance)
function.

    iex> String.jaro_distance("Oscar-Claude Monet", "Monet, Claude")
    0.5407763532763533

    iex> String.jaro_distance("Oscar-Claude Monet", "Edouard Manet")
    0.624928774928775

This is not an improvement over exact equality.

In order to improve the results this library uses two different approaches,
`FuzzyCompare.ChunkSet` and `FuzzyCompare.SortedChunks`.

### Sorted chunks

This approach yields good results when words within a string have been
shuffled around. The strategy will sort all substrings by words and compare
the sorted strings.

    iex> FuzzyCompare.SortedChunks.substring_similarity("Oscar-Claude Monet", "Monet, Claude")
    1.0

    iex(4)> FuzzyCompare.SortedChunks.substring_similarity("Oscar-Claude Monet", "Edouard Manet")
    0.6944444444444443

### Chunkset

The chunkset approach is best in scenarios when the strings contain other
substrings that are not relevant to what is being searched for.

    iex> FuzzyCompare.ChunkSet.standard_similarity("Claude Monet", "Alice Hoschedé was the wife of Claude Monet")
    1.0

### Substring comparison

Should one of the strings be much longer than the other the library will
attempt to compare matching substrings only.

## Credits

This library is inspired by a [seatgeek blogpost from 2011](https://chairnerd.seatgeek.com/fuzzywuzzy-fuzzy-string-matching-in-python/).
