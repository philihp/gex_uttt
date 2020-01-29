defmodule GexUttt.StateTest do
  alias GexUttt.{State, Substate}
  use ExUnit.Case
  
  describe "#advance" do
    test "standard take square" do
      s = %State{}
      s2 = State.advance(s, {:mark, 4, 5})
      assert elem(elem(s2.board, 4).board, 5) == 0
    end
    
    test "advances active player" do
      s = %State{}
      s2 = State.advance(s, {:mark, 4, 5})
      assert s2.active_player == 1
      s3 = State.advance(s2, {:mark, 5, 2})
      assert s3.active_player == 0
    end
    
    test "requires next move on board taken according to last move" do
      s = %State{}
      s2 = State.advance(s, {:mark, 4, 5})
      assert s2.active_board == 5
    end
    
    test "does not require next move if that board is terminal" do
      s = %State{
        board: {
          %Substate{board: {1,1,1,nil,nil,nil,nil,nil,nil}}, 
          %Substate{}, 
          %Substate{}, 
          %Substate{}, 
          %Substate{}, 
          %Substate{}, 
          %Substate{}, 
          %Substate{}, 
          %Substate{}
        }
      }
      s2 = State.advance(s, {:mark, 4, 0})
      assert s2.active_board == nil
    end
  end

  describe "#actions" do
    test "actions for first player" do
      s = %State{}
      assert length(State.actions(s)) == 81
      # first player can go anywhere in 81 spots
    end
    
    test "actions for player, but some spots are taken" do
      s = %State{
        board: {
          %Substate{board: {nil, 1, 0, 1, nil, nil, nil, nil, nil}},
          %Substate{},
          %Substate{},
          %Substate{},
          %Substate{},
          %Substate{},
          %Substate{},
          %Substate{},
          %Substate{}
        }
      }
      assert length(State.actions(s)) == 78
    end
    
    test "actions for player, but must go in a certain open board" do
      s = %State{
        active_board: 4
      }
      assert State.actions(s) == [
        {:mark, 4, 0},
        {:mark, 4, 1},
        {:mark, 4, 2},
        {:mark, 4, 3},
        {:mark, 4, 4},
        {:mark, 4, 5},
        {:mark, 4, 6},
        {:mark, 4, 7},
        {:mark, 4, 8}
      ]
    end
    
    test "actions for certain board, but only open slots" do
      s = %State{
        active_board: 4,
        board: {
          %Substate{},
          %Substate{},
          %Substate{},
          %Substate{},
          %Substate{board: {1, 0, 1, nil, 0, nil, 0, 1, 1}},
          %Substate{},
          %Substate{},
          %Substate{},
          %Substate{}
        }
      }
      assert State.actions(s) == [
        {:mark, 4, 3},
        {:mark, 4, 5},
      ]
    end
  end
end
