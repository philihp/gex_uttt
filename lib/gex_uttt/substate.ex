defmodule GexUttt.Substate do
  alias GexUttt.{Substate}

  defstruct(board: {nil, nil, nil, nil, nil, nil, nil, nil, nil})

  def terminal?(
        state = %Substate{
          board: {
            c00,
            c01,
            c02,
            c10,
            c11,
            c12,
            c20,
            c21,
            c22
          }
        }
      ) do
    (c00 != nil && c01 != nil && c02 != nil &&
       c10 != nil && c11 != nil && c12 != nil &&
       c20 != nil && c21 != nil && c22 != nil) ||
      !!winner(state)
  end

  def actions(state = %Substate{board: board}) do
    if winner(state) do
      []
    else
      open_indexes(Tuple.to_list(board), 0)
    end
  end

  # x x x
  # _ _ _
  # _ _ _
  def winner(%Substate{
        board: {
          s,
          s,
          s,
          _,
          _,
          _,
          _,
          _,
          _
        }
      })
      when s != nil,
      do: s

  # _ _ _
  # x x x
  # _ _ _
  def winner(%Substate{
        board: {
          _,
          _,
          _,
          s,
          s,
          s,
          _,
          _,
          _
        }
      })
      when s != nil,
      do: s

  # _ _ _
  # _ _ _
  # x x x
  def winner(%Substate{
        board: {
          _,
          _,
          _,
          _,
          _,
          _,
          s,
          s,
          s
        }
      })
      when s != nil,
      do: s

  # x _ _
  # x _ _
  # x _ _
  def winner(%Substate{
        board: {
          s,
          _,
          _,
          s,
          _,
          _,
          s,
          _,
          _
        }
      })
      when s != nil,
      do: s

  # _ x _
  # _ x _
  # _ x _
  def winner(%Substate{
        board: {
          _,
          s,
          _,
          _,
          s,
          _,
          _,
          s,
          _
        }
      })
      when s != nil,
      do: s

  # _ _ x
  # _ _ x
  # _ _ x
  def winner(%Substate{
        board: {
          _,
          _,
          s,
          _,
          _,
          s,
          _,
          _,
          s
        }
      })
      when s != nil,
      do: s

  # x _ _
  # _ x _
  # _ _ x
  def winner(%Substate{
        board: {
          s,
          _,
          _,
          _,
          s,
          _,
          _,
          _,
          s
        }
      })
      when s != nil,
      do: s

  # _ _ x
  # _ x _
  # x _ _
  def winner(%Substate{
        board: {
          _,
          _,
          s,
          _,
          s,
          _,
          s,
          _,
          _
        }
      })
      when s != nil,
      do: s

  def winner(_), do: nil

  defp open_indexes([], _) do
    []
  end

  defp open_indexes([nil | tail], i) do
    [i | open_indexes(tail, i + 1)]
  end

  defp open_indexes([_ | tail], i) do
    open_indexes(tail, i + 1)
  end

  def advance(state, {mark, spot}) do
    %Substate{
      state
      | board: put_elem(state.board, spot, mark)
    }
  end
end
