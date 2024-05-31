defmodule TetrisWeb.GameLive do
  alias Tetris.Tetromino
  use TetrisWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(500, :tick)
    end

    {:ok, socket |> new_tetromino |> display}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Welcome to Tetris</h1>
       <%= render_board(assigns) %> <pre>
      <%= inspect @tetro %> 
      </pre>
    </div>
    """
  end

  defp render_board(assigns) do
    ~H"""
    <div>
      <svg width="200" height="400">
        <rect height="400" width="200" style="fill:rgb=(0,0,0);" />
        <%= for {x,y} <- @points do %>
          <.render_points x={x} y={y} shape={color(@tetro.shape)} />
        <% end %>
      </svg>
    </div>
    """
  end

  attr :x, :integer, required: true
  attr :y, :integer, required: true
  attr :shape, :string, required: true

  # <rect height="20" width="20" x={(@x - 1) * 20} y={(@y - 1) * 20} style="fill:rgb(255,0,0);" />
  defp render_points(assigns) do
    ~H"""
    <rect height="20" width="20" x={(@x - 1) * 20} y={(@y - 1) * 20} style={@shape} ; />
    """
  end

  defp color(:l), do: "fill:red"
  defp color(:j), do: "fill:royalblue"
  defp color(:s), do: "fill:limegreen"
  defp color(:z), do: "fill:yellow"
  defp color(:o), do: "fill:magenta"
  defp color(:i), do: "fill:silver"
  defp color(:t), do: "fill:saddlebrown"
  defp color(_), do: "fill:red"

  def new_tetromino(socket) do
    assign(socket, tetro: Tetromino.new_random())
  end

  defp display(socket) do
    assign(socket, points: Tetromino.show(socket.assigns.tetro))
  end

  def rotate(%{assigns: %{tetro: tetro}} = socket) do
    assign(socket, tetro: Tetromino.rotate(tetro))
  end

  def down(%{assigns: %{tetro: %{location: {_, 20}}}} = socket) do
    new_tetromino(socket)
  end

  def down(%{assigns: %{tetro: tetro}} = socket) do
    assign(socket, tetro: Tetromino.down(tetro))
  end

  def handle_info(:tick, socket) do
    {:noreply, socket |> down |> rotate |> display}
  end
end
