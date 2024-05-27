defmodule TetrisWeb.GameLive do
  alias Tetris.Tetromino
  use TetrisWeb, :live_view

  def mount(_params, _session, socket) do
    :timer.send_interval(500, :tick)
    {:ok, socket |> new_tetromino |> display}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Welcome to Tetris</h1>
       <%= render_board(assigns) %> <% [{x, y}] = @points %> <pre> 
        {<%= x%>, <%= y%>} 
      </pre>
    </div>
    """
  end

  defp render_board(assigns) do
    ~H"""
    <div>
      <svg width="200" height="400">
        <rect height="400" width="200" style="fill:rgb=(0,0,0);" /> <% [{x, y}] = @points %>
        <.render_points x={x} y={y} />
      </svg>
    </div>
    """
  end

  attr :x, :integer, required: true
  attr :y, :integer, required: true

  # <rect height="20" width="20" x={(@x - 1) * 20} y={(@y - 1) * 20} style="fill:rgb(255,0,0);" />
  defp render_points(assigns) do
    ~H"""
    <rect height="20" width="20" x={(@x - 1) * 20} y={(@y - 1) * 20} style="fill:rgb(255,0,0);" />
    <%= IO.puts("x: #{@x}, y: #{@y}") %>
    """
  end

  def new_tetromino(socket) do
    assign(socket, tetro: Tetromino.new_random())
  end

  defp display(socket) do
    assign(socket, points: Tetromino.points(socket.assigns.tetro))
  end

  def down(%{assigns: %{tetro: %{location: {_, 20}}}} = socket) do
    new_tetromino(socket)
  end

  def down(%{assigns: %{tetro: tetro}} = socket) do
    assign(socket, tetro: Tetromino.down(tetro))
  end

  def handle_info(:tick, socket) do
    {:noreply, socket |> down |> display}
  end
end
