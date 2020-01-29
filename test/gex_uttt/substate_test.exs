defmodule GexUttt.SubstateTest do
  alias GexUttt.Substate
  use ExUnit.Case

  describe "#winner" do
    test "across top marks win for 0" do
      s = %Substate{
        board: {0, 0, 0, 1, nil, 1, 1, nil, nil}
      }

      assert Substate.winner(s) == 0
    end

    test "across top marks win for 1" do
      s = %Substate{
        board: {1, 1, 1, 0, nil, 0, 0, nil, nil}
      }

      assert Substate.winner(s) == 1
    end

    test "diag up" do
      s = %Substate{
        board: {nil, 0, 1, 0, 1, nil, 1, nil, nil}
      }

      assert Substate.winner(s) == 1
    end

    test "diag down" do
      s = %Substate{
        board: {1, 0, nil, 0, 1, nil, nil, nil, 1}
      }

      assert Substate.winner(s) == 1
    end

    test "draw" do
      s = %Substate{
        board: {0, 0, 1, 1, 1, 0, 0, 0, 1}
      }

      assert Substate.winner(s) == nil
    end

    test "no winner yet" do
      s = %Substate{
        board: {nil, 1, nil, 0, nil, nil, nil, nil, nil}
      }

      assert Substate.winner(s) == nil
    end
  end

  describe "#actions" do
    test "subset" do
      s = %Substate{board: {0, nil, nil, 1, 1, 0, 0, 0, nil}}
      assert Substate.actions(s) == [1, 2, 8]
    end

    test "all available" do
      s = %Substate{board: {nil, nil, nil, nil, nil, nil, nil, nil, nil}}
      assert Substate.actions(s) == [0, 1, 2, 3, 4, 5, 6, 7, 8]
    end

    test "none available" do
      s = %Substate{board: {1, 1, 0, 0, 0, 1, 1, 1, 0}}
      assert Substate.actions(s) == []
    end
  end
  
  describe "#terminal?" do
    test "board with all slots taken is terminal" do
      s = %Substate{board: {1,0,1,0,1,0,1,1,0}}
      assert Substate.winner(s) == 1
      assert Substate.terminal?(s) == true
    end
    
    test "board with some slots taken but no winner is not terminal" do
      s = %Substate{board: {1,1,0,0,0,1,1,1,0}}
      assert Substate.winner(s) == nil
      assert Substate.terminal?(s) == true
    end
    
    test "board with some slots taken and there is a winner is terminal" do
      s = %Substate{board: {0, 0, nil,1, 1, 1, nil, nil, nil}}
      assert Substate.winner(s) == 1
      assert Substate.terminal?(s) == true
    end
  end
end
