defmodule Tetris.Game do
  alias Tetris.{Points, Tetromino}

  defstruct [
    :tetro,
    :next_tetro,
    next_tetro_points: [],
    points: [],
    score: 0,
    junkyard: %{},
    game_over: false
  ]

  def new do
    __struct__()
    |> new_tetromino
    |> next_new
    |> new_tetro_points
    |> show
  end

  def move(game, move_fn) do
    {old, new, valid} = move_data(game, move_fn)

    moved = Tetromino.maybe_move(old, new, valid)

    %{game | tetro: moved}
    |> show
  end

  def move_data(game, move_fn) do
    old = game.tetro

    new =
      game.tetro
      |> move_fn.()

    valid =
      new
      |> Tetromino.show()
      |> Points.valid?(game.junkyard)

    {old, new, valid}
  end

  def left(game), do: move(game, &Tetromino.left/1)

  def right(game), do: move(game, &Tetromino.right/1)

  def down(game) do
    {old, new, valid} = move_data(game, &Tetromino.down/1)
    move_down_or_merge(game, old, new, valid)
  end

  def move_down_or_merge(game, _old, new, true = _valid) do
    %{game | tetro: new}
    |> show
  end

  def move_down_or_merge(game, old, _new, false = _valid) do
    game
    |> merge(old)
    |> new_tetromino
    |> show
    |> check_game_over
    |> next_new
    |> new_tetro_points
  end

  def merge(game, old) do
    new_junkyard =
      old
      |> Tetromino.show()
      |> Enum.map(fn {x, y, _shape} -> {{x, y}, old.shape} end)
      |> Enum.into(game.junkyard)

    %{game | junkyard: new_junkyard}
    |> collapse_rows
  end

  def collapse_rows(game) do
    rows = complete_rows(game)

    game
    |> clear(rows)
    |> score_rows(rows)
  end

  def clear(game, []), do: game

  def clear(game, [y | ys]), do: remove_row(game, y) |> clear(ys)

  def remove_row(game, row) do
    new_junkyard =
      game.junkyard
      |> Enum.reject(fn {{_x, y}, _shape} -> y == row end)
      |> Enum.map(fn {{x, y}, shape} ->
        {{x, maybe_move_y(y, row)}, shape}
      end)
      |> Map.new()

    %{game | junkyard: new_junkyard}
  end

  defp maybe_move_y(y, row) when y < row do
    y + 1
  end

  defp maybe_move_y(y, _row), do: y

  def complete_rows(game) do
    game.junkyard
    |> Map.keys()
    |> Enum.group_by(&elem(&1, 1))
    |> Enum.filter(fn {_y, list} -> length(list) == 10 end)
    |> Enum.map(fn {y, _list} -> y end)
  end

  def junkyard_points(game) do
    game.junkyard
    |> Enum.map(fn {{x, y}, shape} -> {x, y, shape} end)
  end

  def rotate(game), do: move(game, &Tetromino.rotate/1)

  def new_tetromino(%{next_tetro: nil} = game) do
    %{game | tetro: Tetromino.new_random()}
  end

  def new_tetromino(%{next_tetro: next} = game) do
    %{game | tetro: next}
  end

  def next_new(game) do
    %{game | next_tetro: Tetromino.new_random()}
  end

  def show(game) do
    %{game | points: Tetromino.show(game.tetro)}
  end

  def new_tetro_points(game) do
    %{game | next_tetro_points: Tetromino.show(game.next_tetro)}
  end

  def inc_score(game, value) do
    %{game | score: game.score + value}
  end

  def score_rows(game, rows) do
    new_score = :math.pow(2, length(rows)) |> round |> Kernel.*(100)
    %{game | score: new_score + game.score}
  end

  def check_game_over(game) do
    game_over =
      game.tetro
      |> Tetromino.show()
      |> Points.valid?(game.junkyard)

    IO.inspect(game)

    %{game | game_over: !game_over}
  end
end
