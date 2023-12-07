defmodule Day04.Part1 do
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&get_card_nums/1)
    |> Enum.map(fn {_, winnings_nums, my_nums} -> MapSet.intersection(MapSet.new(winnings_nums), MapSet.new(my_nums)) end)
    |> Enum.map(fn intersect ->
      winning_count = Enum.count(intersect)

      if winning_count > 0 do
        Integer.pow(2, winning_count - 1)
      else
        0
      end
    end)
    |> Enum.sum
  end

  def get_card_nums(line) do
    [row_header, cards] = String.split(line, ":", trim: true)
    [_, card_num] = String.split(row_header)
    [winnings_nums, my_nums] = String.split(cards, "|", trim: true)

    wn = winnings_nums |> String.split |> Enum.map(&String.to_integer/1)
    mn = my_nums |> String.split |> Enum.map(&String.to_integer/1)

    {String.to_integer(card_num), wn, mn}
  end

end

defmodule Day04.Part2 do
  def solve(input) do
    cards = input
    |> String.split("\n", trim: true)
    |> Enum.map(&Day04.Part1.get_card_nums/1)
    |> Enum.map(fn {card_num, winnings_nums, my_nums} ->
      intersect = MapSet.intersection(MapSet.new(winnings_nums), MapSet.new(my_nums))
      {card_num, Enum.count(intersect)}
    end)

    map = cards
    |> Enum.map(fn {card_num, _} -> {card_num, 1} end)
    |> Map.new

    # IO.puts("")
    # cards |> Enum.each(fn {card_num, winning_cnt} -> IO.puts("Card #{card_num}: #{winning_cnt}") end)
    # IO.puts("")

    m = Enum.reduce(cards, map, fn {card_num, winning_cnt}, acc ->

      if winning_cnt > 0 do

        Enum.reduce(0..winning_cnt-1, acc, fn idx, a ->
          update_card_num = card_num + idx + 1

          curr_card_cnt = Map.get(a, card_num)
          update_curr_cnt = Map.get(a, update_card_num)
          new_cnt = update_curr_cnt + curr_card_cnt

          # IO.puts("Card: #{card_num}, idx: #{idx}, update card: #{update_card_num}, curr cnt: #{update_curr_cnt}, new cnt: #{new_cnt}")

          Map.put(a, update_card_num, new_cnt)

        end)
      else
        acc
      end

    end)

    # IO.puts("")
    # m |> Enum.each(fn {k, v} -> IO.puts("Card #{k}: #{v}") end)

    m |> Enum.map(fn {_, v} -> v end) |> Enum.sum
  end

end

defmodule Mix.Tasks.Day04 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day04-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day04.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day04.Part2.solve(input))
  end
end
