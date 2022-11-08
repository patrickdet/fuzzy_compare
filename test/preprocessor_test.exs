defmodule PreprocessorTest do
  use ExUnit.Case

  @subject FuzzyCompare.Preprocessor

  test "when replacing whitespace and punctuation in unicode strings the string remains a valid unicode string" do
    result = @subject.process("✔︎")
    assert String.valid?(result.string) == true
  end
end
