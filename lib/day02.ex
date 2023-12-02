defmodule Day02.Part1 do
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&get_game/1)
    |> Enum.filter(fn {_, max_red, max_green, max_blue, } -> max_red <= 12 && max_green <= 13  && max_blue <= 14 end)
    |> Enum.map(fn {game_id, _, _, _} -> game_id end)
    |> Enum.sum()
  end

  def get_game(line) do
    [game, rounds] = String.split(line, ":")
    [_, id] = String.split(game)

    counts = rounds
      |> String.split(";", trim: true)
      |> Enum.flat_map(fn s ->
          String.split(s, ",")
            |> Enum.map(fn s ->
              [count, color] = String.split(s)
              {color, String.to_integer(count)}
            end)
        end)

    max_red = counts |> get_max("red")

    max_green = counts |> get_max("green")

    max_blue = counts |> get_max("blue")

    {String.to_integer(id), max_red, max_green, max_blue}
  end

  def get_max(counts, color) do
    counts
      |> Enum.filter(fn {c, _} -> c == color end)
      |> Enum.map(fn {_, count} -> count end)
      |> Enum.max()
  end

end

defmodule Day02.Part2 do
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&Day02.Part1.get_game/1)
    |> Enum.map(fn {_, max_red, max_green, max_blue} -> max_red * max_green * max_blue end)
    |> Enum.sum()
  end
end

defmodule Mix.Tasks.Day02 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day02-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day02.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day02.Part2.solve(input))
  end
end
