defmodule Day06.Part1 do
  def solve(input) do
    lines = input
    |> String.split("\n", trim: true)

    times = lines |> Enum.at(0)
    |> String.split(":", trim: true)
    |> Enum.drop(1)
    |> Enum.flat_map(&String.split/1)
    |> Enum.map(&String.to_integer/1)

    distances = lines |> Enum.at(1)
    |> String.split(":", trim: true)
    |> Enum.drop(1)
    |> Enum.flat_map(&String.split/1)
    |> Enum.map(&String.to_integer/1)

    time_to_dist_map = times
    |> Enum.with_index( )
    |> Enum.map(fn {time, idx} -> {time, Enum.at(distances, idx)} end)

    IO.puts("")
    time_to_dist_map |> Enum.each(fn {time, dist} -> IO.puts("Time: #{time}, Dist: #{dist}") end)

    time_to_dist_map
    |> Enum.map(fn {time, dist} ->
      throttle_distances = calc_throttle_distances(time)

      cnt = throttle_distances
      |> Enum.filter(fn td -> td > dist end)
      |> Enum.count

      IO.puts("Winnable count: #{cnt}")

      cnt
    end)
    |> Enum.reduce(fn x, acc -> x * acc end)

  end

  def calc_throttle_distances(time) do
    range = Range.new(1, time)

    range |> Enum.map(fn throttle ->

      td = (time - throttle) * throttle

      # IO.puts("Throttle: #{throttle}, dist: #{td}")

      td
    end)

  end

end

defmodule Day06.Part2 do
  def solve(input) do
    lines = input
    |> String.split("\n", trim: true)

    time = lines |> Enum.at(0)
    |> String.split(":", trim: true)
    |> Enum.drop(1)
    |> Enum.flat_map(&String.split/1)
    |> Enum.join
    |> String.to_integer

    dist = lines |> Enum.at(1)
    |> String.split(":", trim: true)
    |> Enum.drop(1)
    |> Enum.flat_map(&String.split/1)
    |> Enum.join
    |> String.to_integer

    IO.puts("")
    IO.puts("Time: #{time}, Dist: #{dist}")

    throttle_distances = Day06.Part1.calc_throttle_distances(time)

    throttle_distances
    |> Enum.filter(fn td -> td > dist end)
    |> Enum.count


  end
end

defmodule Mix.Tasks.Day06 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day06-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day06.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day06.Part2.solve(input))
  end
end
