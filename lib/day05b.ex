# thanks to https://github.com/mwien/adventofcode23/blob/main/5/5.ex
defmodule Day05b.Part1 do
  def solve(input) do
    {seeds, maps} = parse(input)
    Enum.reduce(seeds, 10**18, &(min(&2, location_for_seed(&1, maps))))
  end

  def parse_map([]) do
    {[], []}
  end

  def parse_map(input) do
    [head | tail] = input
    if head == "" do
      {[], tail}
    else
      {map, tail} = parse_map(tail)
      {[Enum.map(String.split(head), &String.to_integer(&1)) | map], tail}
    end
  end

  def parse_maps([]) do
    []
  end

  def parse_maps(input) do
    [head | tail] = input
    if String.ends_with?(head, "map:") do
      {map, tail} = parse_map(tail)
      [map | parse_maps(tail)]
    else
      parse_maps(tail)
    end
  end

  def parse(input) do
    input =
    input
    |> String.split("\n")
    [seedinfo | rest] = input
    [_ | seedinfo] = String.split(seedinfo)
    seedinfo = Enum.map(seedinfo, &String.to_integer(&1))
    maps = parse_maps(rest)
    {seedinfo, maps}
  end

  def check_transform({object, true}, _) do
    {object, true}
  end

  def check_transform({object, done}, [t, s, l]) do
    if s <= object and object < s + l do
      {object - s + t, true}
    else
      {object, done}
    end
  end

  def transform(object, map) do
    {object, _} = Enum.reduce(map, {object, false}, &check_transform(&2, &1))
    object
  end

  def location_for_seed(seed, maps) do
    Enum.reduce(maps, seed, &transform(&2, &1))
  end

end

defmodule Day05b.Part2 do
  def solve(input) do
    {seeds, maps} = Day05b.Part1.parse(input)
    seeds = Enum.chunk_every(seeds, 2)
    ranges = Enum.reduce(maps, seeds, &update_ranges(&2, Enum.sort(&1, fn [_, b1, _], [_, b2, _] -> b1 <= b2 end)))
    Enum.reduce(ranges, 10**18, fn [x, _], mn -> min(x, mn) end)
  end

  def rec_update_range(range, []) do
    [range]
  end

  def rec_update_range([x, off], [[t, s, l] | tail]) do
    if off <= 0 do
      []
    else
      left = [x, min(s, x+off) - x]
      center = [max(x, s) + (t-s), min(x+off, s+l) - max(x, s)]
      right = [max(x, s+l) , x+off - max(x, s+l)]
      [center, left | rec_update_range(right, tail)]
    end
  end

  def update_range(range, map, acc) do
    ranges = rec_update_range(range, map)
    |> Enum.filter(fn [_, off] -> off > 0 end)
    ranges ++ acc
  end

  def update_ranges(ranges, map) do
    Enum.reduce(ranges, [], &update_range(&1, map, &2))
  end
end

defmodule Mix.Tasks.Day05b do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day05-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day05b.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day05b.Part2.solve(input))
  end
end
