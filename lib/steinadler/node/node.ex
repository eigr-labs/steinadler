defmodule Steinadler.Node do
  use GenServer

  defmodule State do
    defstruct id: nil, pubsub_name: nil, gnat: nil, subscription: nil, serializer: nil

    @type t :: %__MODULE__{
            id: Node.t(),
            pubsub_name: String.t(),
            gnat: any(),
            subscription: String.t(),
            serializer: module()
          }
  end

  @main_topic "nodes.*"

  ## Server callbacks

  @impl true
  @doc false
  def init(state) do
    Process.flag(:trap_exit, true)
    nats_conn = Keyword.fetch!(state, :connection)
    pubsub_name = Keyword.get(state, :adapter_name, __MODULE__)
    serializer = Keyword.get(state, :serializer, Nats.Serializer.Native)
    {:ok, %State{pubsub_name: pubsub_name}, {:continue, {:setup, nats_conn, serializer}}}
  end

  @impl true
  def handle_continue({:setup, nats_conn, serializer}, state) do
    {gnat, subscription} =
      case Gnat.start_link(nats_conn) do
        {:ok, gnat} ->
          subscription = sub(gnat)
          {gnat, subscription}

        _ ->
          raise RuntimeError, "Could not connect to Nats with options #{inspect(nats_conn)}"
      end

    {:noreply,
     %State{state | id: node(), gnat: gnat, subscription: subscription, serializer: serializer}}
  end

  @impl true
  def handle_info(
        {:msg, %{topic: topic, reply_to: _to, headers: headers} = event},
        %State{pubsub_name: pubsub_name, serializer: serializer} = state
      ) do
    {:noreply, state}
  end

  def handle_info(event, state) do
    Logger.warning("An unexpected event has occurred. Event: #{inspect(event)}")
    {:noreply, state}
  end

  @impl true
  def terminate(reason, _state) do
    Logger.warning("#{inspect(__MODULE__)} terminate with reason: #{inspect(reason)}")
  end

  ## Client API

  @doc false
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:adapter_name])
  end

  ## Private functions
  defp sub(gnat) do
    case Gnat.sub(gnat, self(), @main_topic) do
      {:ok, subscription} ->
        subscription

      _ ->
        raise RuntimeError,
              "Unable to subscribe Node #{inspect(node())} to channel #{@main_topic}"
    end
  end
end
