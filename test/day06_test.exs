defmodule Day06Test do
  use ExUnit.Case

  @example_input1 """
  Time:      7  15   30
  Distance:  9  40  200
  """
  test "solves example input for part 1" do
    assert Day06.Part1.solve(@example_input1) == 288
  end

  @example_input2 """
  Time:      7  15   30
  Distance:  9  40  200
  """
  test "solves example input for part 2" do
    assert Day06.Part2.solve(@example_input2) == 71503
  end
end
