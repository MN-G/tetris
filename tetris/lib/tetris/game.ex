defmodule Tetris.Game do
  alias Tetris.{Points, Tetromino}
  defstruct [:tetro, points: [], score: 0, junkyard: %{}]

  def new do
    __struct__()
    |> new_tetromino
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
    |> new_tetromino()
    |> show
  end

  def merge(game, old) do
    new_junkyard =
      old
      |> Tetromino.show()
      |> Enum.map(fn {x, y, _shape} -> {{x, y}, old.shape} end)
      |> Enum.into(game.junkyard)

    %{game | junkyard: new_junkyard}
  end

  def junkyard_points(game) do
    game.junkyard
    |> Enum.map(fn {{x, y}, shape} -> {x, y, shape} end)
  end

  def rotate(game), do: move(game, &Tetromino.rotate/1)

  def new_tetromino(game) do
    %{game | tetro: Tetromino.new_random()}
  end

  def show(game) do
    %{game | points: Tetromino.show(game.tetro)}
  end
end
