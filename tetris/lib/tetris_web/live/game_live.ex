defmodule TetrisWeb.GameLive do
  alias Tetris.Tetromino
  use TetrisWeb, :live_view

  def mount(_params, _session, socket) do
    :timer.send_interval(500, :tick)
    {:ok, socket |> new_tetromino}
  end

  def new_tetromino(socket) do
    assign(socket, tetro: Tetromino.new_random())
  end

  def render(assigns) do
    ~H"""
    <div>
      Hello Tetris <pre> <%= inspect @tetro %> </pre>
    </div>
    """
  end

  def down(%{assigns: %{tetro: tetro}} = socket) do
    assign(socket, tetro: Tetromino.down(tetro))
  end

  def handle_info(:tick, socket) do
    {:noreply, down(socket)}
  end
end
