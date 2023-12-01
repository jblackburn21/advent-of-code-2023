defmodule Day01Test do
  use ExUnit.Case

  @example_input1 """
  1abc2
  pqr3stu8vwx
  a1b2c3d4e5f
  treb7uchet
  """
  test "solves example input for part 1" do
    assert Day01.Part1.solve(@example_input1) == 142
  end

  @example_input2 """
  two1nine
  eightwothree
  abcone2threexyz
  xtwone3four
  4nineeightseven2
  zoneight234
  7pqrstsixteen
  """
  #29, 83, 13, 24, 42, 14, and 76
  test "solves example input for part 2" do
    assert Day01.Part2.solve(@example_input2) == 281
  end
end
