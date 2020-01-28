defmodule GexUttt.State do
  alias GexUttt.{State, Substate}
  use Gex.State

  defstruct active_board: nil,
            active_player: 0,
            board: {
              %Substate{},
              %Substate{},
              %Substate{},
              %Substate{},
              %Substate{},
              %Substate{},
              %Substate{},
              %Substate{},
              %Substate{}
            }

  def score(state = %State{}) do
    winner(state) || 0.5
  end

  def terminal?(state = %State{board: [b00, b01, b02, b10, b11, b12, b20, b21, b22]}) do
    (Substate.terminal?(b00) &&
       Substate.terminal?(b01) &&
       Substate.terminal?(b02) &&
       Substate.terminal?(b10) &&
       Substate.terminal?(b11) &&
       Substate.terminal?(b12) &&
       Substate.terminal?(b20) &&
       Substate.terminal?(b21) &&
       Substate.terminal?(b22)) ||
      !!winner(state)
  end

  def winner(%State{board: [b00, b01, b02, b10, b11, b12, b20, b21, b22]}) do
    w00 = Substate.winner(b00)
    w01 = Substate.winner(b01)
    w02 = Substate.winner(b02)
    w10 = Substate.winner(b10)
    w11 = Substate.winner(b11)
    w12 = Substate.winner(b12)
    w20 = Substate.winner(b20)
    w21 = Substate.winner(b21)
    w22 = Substate.winner(b22)

    (w00 && w01 && w02 && w00 == w01 && w01 == w02 && w01) ||
      (w10 && w11 && w12 && w10 == w11 && w11 == w12 && w11) ||
      (w20 && w21 && w22 && w20 == w21 && w21 == w22 && w21) ||
      (w00 && w10 && w20 && w00 == w10 && w10 == w20 && w00) ||
      (w01 && w11 && w21 && w01 == w11 && w11 == w21 && w01) ||
      (w02 && w12 && w22 && w02 == w12 && w12 == w22 && w02) ||
      (w00 && w11 && w22 && w00 == w11 && w11 == w22 && w00) ||
      (w20 && w11 && w02 && w20 == w11 && w11 == w02 && w20) || nil
  end

  def active_player(%State{active_player: active_player}), do: active_player

  def advance(src_state, {:mark, bidx, spot}) do
    dst_substate = Substate.advance(elem(src_state.board, bidx), {src_state.active_player, spot})
    dst_board = put_elem(src_state.board, bidx, dst_substate)

    %State{
      src_state
      | board: dst_board,
        active_board: unless(Substate.winner(elem(dst_board, spot)), do: spot),
        active_player: rem(src_state.active_player + 1, 2)
    }
  end

  def actions(%State{board: board, active_board: nil}) do
    for bidx <- 0..8, into: [] do
      board
      |> elem(bidx)
      |> Substate.actions()
      |> Enum.map(fn spot -> {:mark, bidx, spot} end)
    end
    |> List.flatten()
  end

  def actions(%State{board: board, active_board: bidx}) do
    board
    |> elem(bidx)
    |> Substate.actions()
    |> Enum.map(fn spot -> {:mark, bidx, spot} end)
  end

  def feature_vector(_state), do: []
end
