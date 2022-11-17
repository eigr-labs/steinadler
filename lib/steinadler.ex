defmodule Steinadler do
  @moduledoc """
  `Steinadler`.
  """
  use Supervisor
  require Logger

  @impl true
  def init(opts) do
    children = [
      {Registry, keys: :unique, name: Steinadler.Registry},
      {Steinadler.Node, opts}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end
end
