defmodule Tetris.Points do
  alias Tetris.Point

  def move(points, change) do
    points
    |> Enum.map(fn point -> Point.move(point, change) end)
  end

  def rotate(points, degrees) do
    points
    |> Enum.map(fn point -> Point.rotate(point, degrees) end)
  end

  def valid?(points, junkyard) do
    Enum.all?(points, &Point.valid?(&1, junkyard))
  end
end
