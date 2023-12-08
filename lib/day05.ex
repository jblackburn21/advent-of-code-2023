defmodule Day05.Part1 do
  def solve(input) do
    blocks = input
    |> String.split("\n\n", trim: true)

    seeds_line = Enum.at(blocks, 0)

    seed_nums = seeds_line
    |> String.split(":")
    |> then(fn [_,nums] ->
      nums |> String.split |> Enum.map(&String.to_integer/1)
    end)

    # IO.puts("\nseed to soil map:")
    seed_to_soil_map = Enum.at(blocks, 1) |> parse_map

    # IO.puts("\nsoil to fertilizer map:")
    soil_to_fertilizer_map = Enum.at(blocks, 2) |> parse_map

    # IO.puts("\nfertilizer to water map:")
    fertilizer_to_water_map = Enum.at(blocks, 3) |> parse_map

    # IO.puts("\nwater to light map:")
    water_to_light_map = Enum.at(blocks, 4) |> parse_map

    # IO.puts("\nlight to temperature map:")
    light_to_temp_map = Enum.at(blocks, 5) |> parse_map

    # IO.puts("\ntemperature to humidity map:")
    temp_to_humidity_map = Enum.at(blocks, 6) |> parse_map

    # IO.puts("\nhumidity to location map:")
    humidity_to_location_map = Enum.at(blocks, 7) |> parse_map

    IO.puts("")

    seed_nums
    |> Enum.map(fn seed_num ->

      [
        seed_to_soil_map,
        soil_to_fertilizer_map,
        fertilizer_to_water_map,
        water_to_light_map,
        light_to_temp_map,
        temp_to_humidity_map,
        humidity_to_location_map
      ]
      |> Enum.reduce(seed_num, fn map, num -> get_dest_num(map, num)  end)
    end)
    |> Enum.min
  end

  def parse_map(block) do
    block
    |> String.split("\n")
    |> Enum.drop(1)
    |> Enum.map(&parse_map_line/1)
  end

  def parse_map_line(line) do
    [dest_start, src_start, range_len] = String.split(line)

    ds = String.to_integer(dest_start)
    ss = String.to_integer(src_start)
    rl = String.to_integer(range_len)

    dest_range = Range.new(ds, ds + rl - 1)
    src_range = Range.new(ss, ss + rl - 1)

    {dest_range, src_range}
  end

  def get_dest_num(map, src_num) do
    # {map, num}

    Enum.find_value(map, src_num, fn {
      output_start.._,
      input_range = input_start.._,
    } ->
      if src_num in input_range do
        offset = src_num - input_start
        output_start + offset
      end
    end)
  end

end

defmodule Day05.Part2 do
  def solve(input) do
    blocks = input
    |> String.split("\n\n", trim: true)

    seeds_line = Enum.at(blocks, 0)

    [_, seed_nums_raw] = seeds_line |> String.split(":")
    seed_num_ranges = seed_nums_raw
    |> String.split
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [start_num, range_len] -> start_num..(start_num + range_len - 1) end)

    # IO.puts("\nseed to soil map:")
    seed_to_soil_map = Enum.at(blocks, 1) |> Day05.Part1.parse_map

    # IO.puts("\nsoil to fertilizer map:")
    soil_to_fertilizer_map = Enum.at(blocks, 2) |> Day05.Part1.parse_map

    # IO.puts("\nfertilizer to water map:")
    fertilizer_to_water_map = Enum.at(blocks, 3) |> Day05.Part1.parse_map

    # IO.puts("\nwater to light map:")
    water_to_light_map = Enum.at(blocks, 4) |> Day05.Part1.parse_map

    # IO.puts("\nlight to temperature map:")
    light_to_temp_map = Enum.at(blocks, 5) |> Day05.Part1.parse_map

    # IO.puts("\ntemperature to humidity map:")
    temp_to_humidity_map = Enum.at(blocks, 6) |> Day05.Part1.parse_map

    # IO.puts("\nhumidity to location map:")
    humidity_to_location_map = Enum.at(blocks, 7) |> Day05.Part1.parse_map

    IO.puts("")

    seed_num_ranges
    |> Enum.map(&Range.to_list/1)
    |> List.flatten()
    |> Enum.map(fn seed_num ->
      # IO.puts("Seed: #{seed_num}")
      [
        seed_to_soil_map,
        soil_to_fertilizer_map,
        fertilizer_to_water_map,
        water_to_light_map,
        light_to_temp_map,
        temp_to_humidity_map,
        humidity_to_location_map
      ]
      |> Enum.reduce(seed_num, fn map, num -> Day05.Part1.get_dest_num(map, num)  end)
    end)
    |> Enum.min

  end

end

defmodule Mix.Tasks.Day05 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day05-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day05.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day05.Part2.solve(input))
  end
end
