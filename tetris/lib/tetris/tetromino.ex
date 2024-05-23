defmodule Tetris.Tetromino do
  alias Tetris.Point
  defstruct shape: :l, rotation: 0, location: {5, 1}

  def new(options \\ []) do
    __struct__(options)
  end

  def new_random do
    new(shape: random_shape())
  end

  def points(tetro) do
    [tetro.location]
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
end
