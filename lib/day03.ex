defmodule Day03.Part1 do
  def solve(input) do
    lines = input
    |> String.split("\n", trim: true)
    |> Enum.with_index

    symbols = lines
    |> Enum.flat_map(fn {line, row} ->
        line
        |> String.graphemes
        |> Enum.with_index
        |> Enum.filter(fn {char, _} -> is_symbol(char) end)
        |> Enum.map(fn {char, col} -> {{row, col}, char} end)
      end)
    |> Map.new

    adjacent_numbers = get_digits(lines, symbols)
      |> get_digit_chunks
      |> Enum.filter(fn chunk -> chunk |> Enum.any?(fn {_, {_, _}, is_adjacent} -> is_adjacent end) end)
      |> Enum.map(fn chunk -> chunk
        |> Enum.map(fn {digit, {_, _}, _} -> digit end)
        |> Enum.join
        end)
      |> Enum.map(&String.to_integer/1)

    # adjacent_numbers |> Enum.each(&IO.puts/1)

    adjacent_numbers |> Enum.sum

  end

  def is_digit(char) do
    case Integer.parse(char) do
      {_, ""} -> true
      _ -> false
    end
  end

  def is_symbol(char) do
    (char != ".") && !is_digit(char)
  end

  def get_digits(lines, symbols) do
    lines
    |> Enum.flat_map(fn {line, row} ->
        line
        |> String.graphemes
        |> Enum.with_index
        |> Enum.filter(fn {char, _} -> is_digit(char) end)
        |> Enum.map(fn {digit, col} ->
          {{row, col}, digit, is_adjacent(symbols, {row, col})} end)
        |> Enum.group_by(fn {{row, _}, _, _} -> row end)
      end)
  end

  def get_digit_chunks(rows) do
    rows
    |> Enum.flat_map(fn {_, row} ->
        chunk_fun = fn {{r, col}, digit, is_adjacent}, acc ->

        col_idx = Enum.find_index(row, fn {{_,c}, _, _} -> col == c end)

        end_of_chunk = if col_idx == Enum.count(row) - 1 do
          true
        else
          {{_, next_col}, _, _} = Enum.at(row, col_idx + 1)
          col < next_col - 1
        end

        # IO.puts("{#{r},#{col}}, digit: #{digit}, end chunk: #{end_of_chunk}")

        if end_of_chunk do
          {:cont, Enum.concat(acc, [{digit, {r, col}, is_adjacent}]), []}
        else
          {:cont, Enum.concat(acc, [{digit, {r, col}, is_adjacent}])}
        end
      end

      after_fun = fn
        [] -> {:cont, []}
        acc -> {:cont, acc, []}
      end

      Enum.chunk_while(row, [], chunk_fun, after_fun)
    end)
  end

  def is_adjacent(map, {row, col}) do
    checks =
    [
      Map.has_key?(map, {row-1, col}),
      Map.has_key?(map, {row+1, col}),
      Map.has_key?(map, {row, col-1}),
      Map.has_key?(map, {row, col+1}),
      Map.has_key?(map, {row-1, col-1}),
      Map.has_key?(map, {row-1, col+1}),
      Map.has_key?(map, {row+1, col-1}),
      Map.has_key?(map, {row+1, col+1})
    ]

    checks |> Enum.any?(fn x -> x end)
  end

end

defmodule Day03.Part2 do
  def solve(input) do
    lines = input
    |> String.split("\n", trim: true)
    |> Enum.with_index

    gears = lines
    |> Enum.flat_map(fn {line, row} ->
        line
        |> String.graphemes
        |> Enum.with_index
        |> Enum.filter(fn {char, _} -> is_gear(char) end)
        |> Enum.map(fn {char, col} -> {{row, col}, char} end)
      end)
    |> Map.new

    part_nums = Day03.Part1.get_digits(lines, gears)
    |> Day03.Part1.get_digit_chunks
    |> Enum.map(fn chunk ->
      {_, {_, start_col}, _} = chunk |> Enum.at(0)
      {_, {row, end_col}, _} = chunk |> Enum.at(Enum.count(chunk) - 1)

      # IO.puts("First digit: {#{row},#{start_col}} #{first_digit}, Last digit: {#{row},#{end_col}} #{last_digit}")

      num = chunk
      |> Enum.map(fn {digit, {_, _}, _} -> digit end)
      |> Enum.join()
      |> String.to_integer

      {{row, {start_col, end_col}}, num}
    end)

    # part_nums |> Enum.each(fn {{row, {start_col, end_col}}, num} -> IO.puts("{#{row},{#{start_col},#{end_col}}: #{num}") end)

    adjacent_part_nums = gears
    |> Enum.map(fn {{row, col},_} ->

      apn = part_nums
      |> Enum.filter(fn {{p_row, {start_col, end_col}}, _} ->
          check = (p_row == row - 1 && ((start_col <= col && col <= end_col) || start_col == col + 1 || end_col == col - 1))
          || (p_row == row && (start_col == col + 1 || end_col == col - 1))
          || (p_row == row + 1 && ((start_col <= col && col <= end_col) || start_col == col + 1 || end_col == col - 1))

          # IO.puts("Checking: {#{row},#{col}}, {#{p_row},{#{start_col},#{end_col}}} -> #{check}")

          check
      end)

      {{row, col}, apn}
    end)

    adjacent_part_nums
    |> Enum.filter(fn {{_, _}, apn} -> Enum.count(apn) == 2 end)
    |> Enum.map(fn {{_, _}, apn} ->
      apn
      |> Enum.map(fn {{_, {_, _}}, num} -> num end)
      |> Enum.reduce(fn x, acc -> x * acc end) end)
    |> Enum.sum
  end

  def is_gear(char) do
    char == "*"
  end

end

defmodule Mix.Tasks.Day03 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day03-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day03.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day03.Part2.solve(input))
  end
end
