defmodule Steinadler.StreamRef do
  @moduledoc """

  `StreamRefs` allow streams to run on multiple nodes within a cluster.

  StreamRefs are references to existing parts of a stream and can be used to create a distributed processing framework.

  When to use:
  * In systems that expect long-running streams of data between two entities.
  * Point-to-Point streaming without the need to set up additional message brokers.
  * In which you need to send messages between nodes in a flow-controlled fashion.

  Terminology:

  Sink: Designates a stream producer. This in turn forwards the created stream
        to be processed on another node by a consumer aka Source.

        Source: Designates a consumer stream, most likely the initial stream was created on another node in the cluster
          and sent remotely to be consumed on the node that implements part of the stream's processing.

  Examples:

  Define a Sink.

  ```elixir
  defmodule SinkStreamRef do
    use Steinadler.StreamRef, as: :sink, name: __MODULE__
    def sink(_opts) do
      node = :"node1@127.0.0.1"
      flow = Flow.from_enumerable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
      {:ok, node, "multiplier", flow}
    end
  end
  ```

  Define a Source.

  ```elixir
  defmodule SourceStreamRef do
    use Steinadler.StreamRef, as: :source, refname: "multiplier"
    def source(flow, _opts) do
      process_flow = Flow.map(flow, fn elem -> elem * 2 end) |> Flow.each(fn item -> IO.inspect(item) end)
      {:ok, process_flow}
    end
  end
  ```

  Registering flows:

  On some node.

  ```elixir
  SinkStreamRef.start_link()
  ```

  On another node.

  ```elixir
  SourceStreamRef.start_link()
  # Print
  2
  4
  6
  8
  10
  ...
  ```
  """

  @type opts :: any()

  @type node_address :: atom()

  @callback sink(opts()) :: {:ok, node_address(), Flow.t()}
  @callback source(Flow.t(), opts()) :: {:ok, Flow.t()}
  @optional_callbacks sink: 1, source: 2

  @doc false
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      require Logger
      @behaviour Steinadler.StreamRef

      @options opts

      def start_link(options \\ []) do
        merge_opts = Keyword.merge(options, @options)

        case Keyword.fetch!(merge_opts, :as) do
          :sink ->
            # Do something to initialize sink
            name = Keyword.fetch!(merge_opts, :name)
            IO.inspect(name)
            nil

          :source ->
            name = Keyword.fetch!(merge_opts, :refname)

            child = {Steinadler.StreamRef.Producer, %{refname: name}}

            case DynamicSupervisor.start_child(Steinadler.DynamicSupervisor, child) do
              {:ok, producer_pid} ->
                window = Keyword.get(merge_opts, :window)

                flow_opts =
                  if is_nil(window) do
                    [stages: 1, buffer_size: :infinity]
                  else
                    [stages: 1, buffer_size: :infinity, window: window]
                  end

                case __MODULE__.source(
                       Flow.from_stages([producer_pid], flow_opts),
                       merge_opts
                     ) do
                  {:ok, flow} ->
                    Logger.debug("Starting Consumer Flow with name #{inspect(name)}")

                    spawn_link(fn ->
                      Flow.run(flow)
                    end)

                  unknown ->
                    Logger.warn("Unknown return state #{inspect(unknown)}")
                end

              {:error, error} ->
                Logger.warn("Error during Consumer start. Error #{inspect(error)}")
            end
        end
      end
    end
  end
end
