defmodule Day07Test do
  use ExUnit.Case

  @example_input1 """
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
  """
  test "solves example input for part 1" do
    assert Day07.Part1.solve(@example_input1) == 6440
  end

  @example_input2 """
  J253K 345
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
  """
  #29, 83, 13, 24, 42, 14, and 76
  test "solves example input for part 2" do
    assert Day07.Part2.solve(@example_input2) == 5905
  end
end
