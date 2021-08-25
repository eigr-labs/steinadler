defmodule Steinadler.Dist.Protocol.StreamSupervisor do
  use DynamicSupervisor

  @doc false
  def start_link(_opts),
    do: DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)

  @impl true
  def init(_opts), do: DynamicSupervisor.init(strategy: :one_for_one)

  @spec add_stream_to_supervisor(map()) :: {:ok, pid()}
  def add_stream_to_supervisor(args) do
    child_spec = %{
      id: Steinadler.Dist.Protocol.StreamServer,
      start: {Steinadler.Dist.Protocol.StreamServer, :start_link, [args]},
      restart: :transient
    }

    case DynamicSupervisor.start_child(__MODULE__, child_spec) do
      {:error, {:already_started, pid}} -> {:ok, pid}
      {:ok, pid} -> {:ok, pid}
    end
  end

  @spec already_exists?(any) :: boolean
  def already_exists?(stream_pid) do
    Registry.lookup(Steinadler.Registry, stream_pid) !=
      []
  end
end
