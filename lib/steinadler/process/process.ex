defmodule Steinadler.Process do
  @moduledoc """

  """
  use GenServer
  use Retry
  require Logger

  alias Steinadler.Dist.Protocol.ProcessRequest

  @impl true
  @spec init(any) :: {:ok, any}
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(
        {:handle,
         %ProcessRequest{mod: mod, fun: fun, args: args, request_hash: _key, async: _async} =
           _request},
        from,
        state
      ) do
    # TODO: Cached this conversion work
    module = String.to_existing_atom(mod)
    function = String.to_existing_atom(fun)
    arguments = parse_arguments(args)

    spawn(fn ->
      res =
        retry with: exponential_backoff() |> cap(1_000) |> expiry(30_000) do
          apply(module, function, arguments)
        after
          result -> result
        else
          error -> error
        end

      GenServer.reply(from, handle_result(res))
    end)

    {:noreply, state}
  end

  @spec handle(Steinadler.Dist.Protocol.ProcessRequest.t()) :: any
  def handle(%ProcessRequest{} = request) do
    GenServer.call(__MODULE__, {:handle, request}, 35000)
  end

  defp parse_arguments(_args) do
    []
  end

  defp handle_result(res) do
    {:ok, res}
  end
end
