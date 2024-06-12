defmodule TetrisWeb.GameLive.GameOver do
  use TetrisWeb, :live_view
  alias Tetris.Game

  def mount(_params, _session, socket) do
    {:ok, assign(socket, game: Map.get(socket.assigns, :game) || Game.new())}
  end

  defp new_game(socket) do
    socket
    |> push_redirect(to: "/game/playing")
  end

  def handle_event("new_game", _, socket) do
    {:noreply, new_game(socket)}
  end
end
