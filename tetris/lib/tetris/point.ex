defmodule Tetris.Point do
  def origin() do
    {0, 0}
  end

  def left({x, y}) do
    {x - 1, y}
  end

  def right({x, y}) do
    {x + 1, y}
  end

  def down({x, y}) do
    {x, y + 1}
  end

  def move({x, y}, {dx, dy}) do
    {x + dx, y + dy}
  end

  def transpose({x, y}) do
    {y, x}
  end

  def mirror({x, y}) do
    {5 - x, y}
  end

  def flip({x, y}) do
    {x, 5 - y}
  end

  def rotate(point, 0), do: point

  def rotate(point, 90) do
    point |> flip() |> transpose()
  end

  def rotate(point, 180) do
    point |> mirror() |> flip()
  end

  def rotate(point, 270) do
    point |> mirror() |> transpose()
  end
end
