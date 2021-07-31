defmodule SteinadlerTest do
  use ExUnit.Case

  test "bind localhost on port 4369" do
    assert :ok = Steinadler.bind("localhost", 4369)
  end

  test "connect to node" do
    assert :ok = Steinadler.connect("name", "localhost", 4369)
  end
end
