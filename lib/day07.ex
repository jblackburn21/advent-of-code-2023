defmodule Day07.Part1 do

  @cards [:'2', :'3', :'4', :'5', :'6', :'7', :'8', :'9', :T, :J, :Q, :K, :A]

  @hand_types [
    :five_of_kind,
    :four_of_kind,
    :full_house,
    :three_of_kind,
    :two_pair,
    :one_pair,
    :high_card
  ]

  def solve(input) do
    hands = input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [hand, bid] = String.split(line)

      atoms = String.graphemes(hand) |> Enum.map(&String.to_atom/1)
      {atoms, String.to_integer(bid)}
    end)
    |> Enum.map(fn {hand, bid} ->
      hand_type = get_hand_type(hand)

      {hand, hand_type, bid}
    end)

    sorted_hands = hands
    |> Enum.sort_by(&(&1), fn {h1,ht1,_}, {h2,ht2,_} ->
      ht1_idx = get_hand_type_idx(ht1)
      ht2_idx = get_hand_type_idx(ht2)

      if ht1_idx == ht2_idx do
        zip = Enum.zip(h1, h2)
        |> Enum.drop_while(fn {h1c, h2c} -> h1c == h2c end)

        {h1c, h2c} = Enum.at(zip, 0)
        h1c_idx = get_card_type_idx(@cards, h1c)
        h2c_idx = get_card_type_idx(@cards, h2c)

        # IO.puts("h1c1: #{h1c1} -> #{h1c1_idx}, h2c1: #{h2c1} -> #{h2c1_idx}")

        h1c_idx < h2c_idx
      else
        ht1_idx > ht2_idx
      end
    end)

    # sorted_hands |> Enum.each(fn {hand, hand_type, bid} ->
    #   IO.puts("Hand: {#{Enum.join(hand,",")}}, Type: #{hand_type}, Bid: #{bid}")
    # end)

    sorted_hands
    |> Enum.with_index
    |> Enum.reduce(0, fn {{_,_,bid}, rank}, acc -> acc + (bid * (rank + 1)) end)
  end

  def get_hand_type(hand) do
    map = Enum.frequencies(hand)

    max_group = map |> Enum.map(fn {_,v} -> v end) |> Enum.max
    pair_cnt = map |> Enum.count(fn {_,v} -> v == 2 end)

    cond do
      max_group == 5 -> :five_of_kind
      max_group == 4 -> :four_of_kind
      max_group == 3 && pair_cnt == 1 -> :full_house
      max_group == 3 -> :three_of_kind
      pair_cnt == 2 -> :two_pair
      pair_cnt == 1 -> :one_pair
      true -> :high_card
    end

  end

  def get_card_type_idx(cards, card) do
    Enum.find_index(cards, fn c -> c == card end)
  end

  def get_hand_type_idx(hand_type) do
    Enum.find_index(@hand_types, fn ht -> ht == hand_type end)
  end
end

defmodule Day07.Part2 do

  @cards [:J, :'2', :'3', :'4', :'5', :'6', :'7', :'8', :'9', :T, :Q, :K, :A]

  def solve(input) do
    hands = input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [hand, bid] = String.split(line)

      atoms = String.graphemes(hand) |> Enum.map(&String.to_atom/1)
      {atoms, String.to_integer(bid)}
    end)
    |> Enum.map(fn {hand, bid} ->
      hand_type = get_hand_type(hand)

      {hand, hand_type, bid}
    end)

    sorted_hands = hands
    |> Enum.sort_by(&(&1), fn {h1,ht1,_}, {h2,ht2,_} ->
      ht1_idx = Day07.Part1.get_hand_type_idx(ht1)
      ht2_idx = Day07.Part1.get_hand_type_idx(ht2)

      if ht1_idx == ht2_idx do
        zip = Enum.zip(h1, h2)
        |> Enum.drop_while(fn {h1c, h2c} -> h1c == h2c end)

        {h1c, h2c} = Enum.at(zip, 0)
        h1c_idx = Day07.Part1.get_card_type_idx(@cards, h1c)
        h2c_idx = Day07.Part1.get_card_type_idx(@cards, h2c)

        # IO.puts("h1c1: #{h1c1} -> #{h1c1_idx}, h2c1: #{h2c1} -> #{h2c1_idx}")

        h1c_idx < h2c_idx
      else
        ht1_idx > ht2_idx
      end
    end)

    # sorted_hands |> Enum.each(fn {hand, hand_type, bid} ->
    #   IO.puts("Hand: {#{Enum.join(hand,",")}}, Type: #{hand_type}, Bid: #{bid}")
    # end)

    sorted_hands
    |> Enum.with_index
    |> Enum.reduce(0, fn {{_,_,bid}, rank}, acc -> acc + (bid * (rank + 1)) end)
  end

  def get_hand_type(hand) do
    map = Enum.frequencies(hand)

    joker_count = map |> Map.get(:J, 0)

    without_jokers = map |> Enum.filter(fn {k,_} -> k != :J end)

    max_group = if Enum.count(without_jokers) > 0 do
      without_jokers |> Enum.map(fn {_,v} -> v end) |> Enum.max
    else
      0
    end
    pair_count = without_jokers |> Enum.count(fn {_,v} -> v == 2 end)

    {max_group_with_jokers, pair_cnt_with_jokers} = cond do
    joker_count == 4 || joker_count == 5 -> {5,0} # JJJJ5, JJJJJ
    joker_count == 3 && pair_count == 1 -> {5, 0} # JJJ44
    joker_count == 3 && pair_count == 0 -> {4, 0} # JJJ45
    joker_count == 2 && max_group == 3 -> {5,0} # JJ333
    joker_count == 2 && pair_count == 1 -> {4,0} # JJ334
    joker_count == 2 && pair_count == 0 -> {3,0} # JJ345
    joker_count == 1 && max_group == 4 -> {5,0} # J2222
    joker_count == 1 && max_group == 3 -> {4,0} # J2223
    joker_count == 1 && pair_count == 2 -> {3,1} # J2233
    joker_count == 1 && pair_count == 1 -> {3,0} # J2234
    joker_count == 1 && pair_count == 0 -> {2,1} # J2345
    joker_count == 0 -> {max_group, pair_count} # 23456
    end

    hand_type = cond do
      max_group_with_jokers == 5 -> :five_of_kind
      max_group_with_jokers == 4 -> :four_of_kind
      max_group_with_jokers == 3 && pair_cnt_with_jokers == 1 -> :full_house
      max_group_with_jokers == 3 -> :three_of_kind
      pair_cnt_with_jokers == 2 -> :two_pair
      pair_cnt_with_jokers == 1 -> :one_pair
      true -> :high_card
    end

    # IO.puts("Jokers: #{joker_count}, Max: #{max_group}, Max group with jokers: #{max_group_with_jokers}, Pairs: #{pair_count}, Pairs with jokers: #{pair_cnt_with_jokers}, Type: #{hand_type}")

    hand_type
  end
end

defmodule Mix.Tasks.Day07 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day07-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day07.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day07.Part2.solve(input))
  end
end
