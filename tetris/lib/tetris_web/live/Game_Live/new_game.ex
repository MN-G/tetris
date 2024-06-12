defmodule TetrisWeb.GameLive.NewGame do
  use TetrisWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  defp new_game(socket) do
    socket
    |> push_redirect(to: "/game/playing")
  end

  def handle_event("new_game", _, socket) do
    {:noreply, new_game(socket)}
  end
end
