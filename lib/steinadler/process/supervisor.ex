defmodule Steinadler.Process.Supervisor do
  @moduledoc false
  use Supervisor

  @impl true
  def init(args) do
    children = [
      {Steinadler.Process, [args]}
    ]

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 1_000)
  end

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end
end
