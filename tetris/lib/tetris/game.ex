defmodule Tetris.Game do
  alias Tetris.{Points, Tetromino}
  defstruct [:tetro, points: [], score: 0, junkyard: %{}]

  def move(game, move_fn) do
    # old
    # new
    # valid
    # maybe_move
    old = game.tetro

    new =
      game.tetro
      |> move_fn.()

    valid =
      new
      |> Tetromino.show()
      |> Points.valid?()

    Tetromino.maybe_move(old, new, valid)
  end

  def left(game), do: move(game, &Tetromino.left/1)

  def right(game), do: move(game, &Tetromino.right/1)

  def rotate(game), do: move(game, &Tetromino.rotate/1)

  def new_tetromino(game) do
    %{game | tetro: Tetromino.new_random()}
  end

  def show(game) do
    %{game | points: Tetromino.show(game.tetro)}
  end
end
