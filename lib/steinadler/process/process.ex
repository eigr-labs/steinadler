defmodule Steinadler.Process do
  @moduledoc """

  """
  use GenServer
  use Retry
  require Logger

  import Steinadler.Dist.Protocol.TypeConversions
  alias Steinadler.Dist.Protocol.ProcessRequest

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      shutdown: 60_000,
      restart: :transient
    }
  end

  @impl true
  @spec init(any) :: {:ok, any}
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(
        {:handle,
         %ProcessRequest{mod: mod, fun: fun, args: args, request_hash: key, async: _async} =
           _request},
        from,
        state
      ) do
    with {:ok, %{module: module, function: function, arguments: arguments}} <-
           Cachex.get(:function_calls, key) do
      Logger.debug("Found params on cache with key #{inspect(key)}")
      send(from, module, function, arguments)
    else
      _ ->
        module = String.to_existing_atom(mod)
        function = String.to_existing_atom(fun)
        arguments = parse_arguments(args)
        params = %{module: module, function: function, arguments: arguments}
        Cachex.put(:function_calls, key, params)
        send(from, module, function, arguments)
    end

    {:noreply, state}
  end

  @doc false
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @spec handle(Steinadler.Dist.Protocol.ProcessRequest.t()) :: any
  def handle(%ProcessRequest{} = request) do
    GenServer.call(__MODULE__, {:handle, request}, 45000)
  end

  defp parse_arguments(args), do: args |> Enum.map(&from/1)

  defp send(from, module, function, arguments) do
    spawn(fn ->
      res =
        retry with: exponential_backoff() |> cap(1_000) |> expiry(15_000) do
          apply(module, function, arguments)
        after
          result ->
            {:ok, result}
        else
          error ->
            {:error, error}
        end

      GenServer.reply(from, handle_result(res))
    end)
  end

  defp handle_result(res) do
    res
  end
end
