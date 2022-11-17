defmodule SteinadlerTest.Support.Mod do
  defstruct property: nil

  def some_function(), do: {:ok, %__MODULE__{property: 1}}

  def some_function_with_args(property) do
    {:ok, %__MODULE__{property: property}}
  end
end
