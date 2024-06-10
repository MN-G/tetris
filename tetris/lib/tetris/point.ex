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

  def add_shape({x, y} = _point, shape) do
    {x, y, shape}
  end

  def add_shape(point_with_shape, _shape) do
    point_with_shape
  end

  def valid?(point, junkyard) do
    in_bounds?(point) and !colide?(point, junkyard)
  end

  def in_bounds?({x, _y, _c}) when x < 1, do: false
  def in_bounds?({x, _y, _c}) when x > 10, do: false
  def in_bounds?({_x, y, _c}) when y > 20, do: false
  def in_bounds?(_point), do: true

  def colide?({x, y, _c}, junkyard), do: colide?({x, y}, junkyard)
  def colide?(point, junkyard), do: !!junkyard[point]
end
