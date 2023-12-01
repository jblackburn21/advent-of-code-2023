defmodule Day01.Part1 do
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&get_digits/1)
    |> Enum.map(&get_number/1)
    |> Enum.sum()
  end

  def get_digits(line) do
    line
    |> String.graphemes()
    |> Enum.filter(fn x ->
      case Integer.parse(x) do
        {_, ""} -> true
        _ -> false
      end
    end)
  end

  def get_number(digits) do
    first_digit = Enum.at(digits, 0)
    last_digit = Enum.at(digits, Enum.count(digits) - 1)

    Enum.join([first_digit, last_digit])
    |> String.to_integer
  end

end

defmodule Day01.Part2 do
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.replace("one", "one1one")
      |> String.replace("two", "two2two")
      |> String.replace("three", "three3three")
      |> String.replace("four", "four4four")
      |> String.replace("five", "five5five")
      |> String.replace("six", "six6six")
      |> String.replace("seven", "seven7seven")
      |> String.replace("eight", "eight8eight")
      |> String.replace("nine", "nine9nine")
    end)
    |> Enum.map(&Day01.Part1.get_digits/1)
    |> Enum.map(&Day01.Part1.get_number/1)
    |> Enum.sum()
  end

end

defmodule Mix.Tasks.Day01 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day01-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day01.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day01.Part2.solve(input))
  end
end
