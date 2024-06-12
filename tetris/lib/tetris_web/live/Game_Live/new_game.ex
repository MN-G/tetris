defmodule TetrisWeb.GameLive.NewGame do
  use TetrisWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end

