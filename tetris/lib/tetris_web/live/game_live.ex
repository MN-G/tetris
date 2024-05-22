defmodule TetrisWeb.GameLive do
  use TetrisWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>Hello Tetris</div>
    """
  end
end
