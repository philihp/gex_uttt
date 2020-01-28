defmodule GexUttt.Game do
  @behaviour Gex.Game

  alias GexUttt.State

  def default_state do
    %State{}
  end

  def view(state) do
    state
  end
end
