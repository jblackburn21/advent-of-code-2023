defmodule Day03Test do
  use ExUnit.Case

  @example_input1 """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """
  test "solves example input for part 1" do
    assert Day03.Part1.solve(@example_input1) == 4361
  end

  @example_input2 """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """
  #29, 83, 13, 24, 42, 14, and 76
  test "solves example input for part 2" do
    assert Day03.Part2.solve(@example_input2) == 467835
  end
end
