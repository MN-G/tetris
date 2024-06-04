defmodule Tetris.Game do
  alias Tetris.{Points, Tetromino}
  defstruct [:tetro, score: 0, junkyard: %{}]

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
end
