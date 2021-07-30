defmodule SteinadlerTest do
  use ExUnit.Case
  doctest Steinadler

  test "greets the world" do
    assert Steinadler.hello() == :world
  end
end
