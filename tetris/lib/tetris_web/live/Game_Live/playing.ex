defmodule TetrisWeb.GameLive.Playing do
  alias Tetris.Game
  use TetrisWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(500, :tick)
    end

    {:ok, new_game(socket)}
  end

  defp render_board(assigns) do
    ~H"""
    <div>
      <svg width="200" height="400">
        <rect height="400" width="200" style="fill:rgb=(0,0,0);" />
        <%= for {x,y,shape} <- @game.points ++ Game.junkyard_points(@game) do %>
          <.render_points x={x} y={y} shape={color(shape)} />
        <% end %>
      </svg>
    </div>
    """
  end

  attr :x, :integer, required: true
  attr :y, :integer, required: true
  attr :shape, :string, required: true

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

  def new_game(socket) do
    assign(socket, game: Game.new())
  end

  def new_tetromino(socket) do
    assign(socket, game: Game.new_tetromino(socket.assigns.game))
  end

  def rotate(%{assigns: %{game: game}} = socket) do
    assign(socket, game: Game.rotate(game))
  end

  def left(%{assigns: %{game: game}} = socket) do
    assign(socket, game: Game.left(game))
  end

  def right(%{assigns: %{game: game}} = socket) do
    assign(socket, game: Game.right(game))
  end

  def down(%{assigns: %{game: game}} = socket) do
    assign(socket, game: Game.down(game))
  end

  def maybe_end_game(%{assigns: %{game: %{game_over: true}}} = socket) do
    socket
    |> push_redirect(to: "/game/game_over")
 end 

  def maybe_end_game(socket), do: socket

  def handle_info(:tick, socket) do
    {:noreply, socket |> maybe_end_game |> down}
  end

  def handle_event("keystroke", %{"key" => "f"}, socket) do
    {:noreply, socket |> rotate}
  end

  def handle_event("keystroke", %{"key" => "h"}, socket) do
    {:noreply, socket |> left}
  end

  def handle_event("keystroke", %{"key" => "l"}, socket) do
    {:noreply, socket |> right}
  end

  def handle_event("keystroke", %{"key" => "j"}, socket) do
    {:noreply, socket |> down}
  end

  def handle_event("keystroke", _key, socket) do
    {:noreply, socket}
  end
end

