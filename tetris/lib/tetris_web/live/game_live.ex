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
        <rect height="400" width="200" style="fill:rgb=(0,0,0);" /> <%= render_points(assigns) %>
      </svg>
    </div>
    """
  end

  attr :x, :integer, required: true
  attr :y, :integer, required: true
  attr :myself, :any, required: true

  defp render_points(assigns) do
    ~H"""
    <rect height="20" width="20" x={(@x - 1) * 20} y={@y(-1) * 20} style="fill:rgb=(255,0,0);" />
    """
  end

  def new_tetromino(socket) do
    assign(socket, tetro: Tetromino.new_random())
  end

  defp display(socket) do
    assign(socket, points: Tetromino.points(socket.assigns.tetro))
  end

  def down(%{assigns: %{tetro: tetro}} = socket) do
    socket
    |> assign(tetro: Tetromino.down(tetro))
    |> display()
  end

  def handle_info(:tick, socket) do
    {:noreply, down(socket)}
  end
end
