defmodule Tetris.Tetromino do
  alias Tetris.{Point, Points}
  defstruct shape: :l, rotation: 0, location: {3, 0}

  def new(options \\ []) do
    __struct__(options)
  end

  def new_random do
    new(shape: random_shape())
  end

  def show(tetro) do
    tetro
    |> points
    |> Points.rotate(tetro.rotation)
    |> Points.move(tetro.location)
  end

  def points(%{shape: :l} = _tetro) do
    [
      {2, 1},
      {2, 2},
      {2, 3},
      {3, 3}
    ]
  end

  def points(%{shape: :j} = _tetro) do
    [
      {3, 1},
      {3, 2},
      {2, 3},
      {3, 3}
    ]
  end

  def points(%{shape: :i} = _tetro) do
    [
      {2, 1},
      {2, 2},
      {2, 3},
      {2, 4}
    ]
  end

  def points(%{shape: :t} = _tetro) do
    [
      {1, 2},
      {2, 2},
      {3, 2},
      {2, 3}
    ]
  end

  def points(%{shape: :o} = _tetro) do
    [
      {2, 2},
      {2, 3},
      {3, 2},
      {3, 3}
    ]
  end

  def points(%{shape: :s} = _tetro) do
    [
      {2, 2},
      {3, 2},
      {1, 3},
      {2, 3}
    ]
  end

  def points(%{shape: :z} = _tetro) do
    [
      {1, 2},
      {2, 2},
      {2, 3},
      {3, 3}
    ]
  end

  defp random_shape do
    ~w(i t o l j z s)a
    |> Enum.random()
  end

  def right(tetro) do
    %{tetro | location: Point.right(tetro.location)}
  end

  def left(tetro) do
    %{tetro | location: Point.left(tetro.location)}
  end

  def down(tetro) do
    %{tetro | location: Point.down(tetro.location)}
  end

  def rotate(tetro) do
    %{tetro | rotation: rotate_degrees(tetro.rotation)}
  end

  defp rotate_degrees(270), do: 0
  defp rotate_degrees(d), do: d + 90
  def maybe_move(_old, new, true = _valid), do: new
  def maybe_move(old, _new, false = _valid), do: old
end
