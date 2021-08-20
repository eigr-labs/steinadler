defmodule Steinadler.Process do
  @moduledoc """

  """
  use GenServer
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
      res = apply(module, function, arguments)
      GenServer.reply(from, handle_result(res))
    end)

    {:noreply, state}
  end

  @spec handle(Steinadler.Dist.Protocol.ProcessRequest.t()) :: any
  def handle(%ProcessRequest{} = request) do
    GenServer.call(__MODULE__, {:handle, request})
  end

  defp parse_arguments(_args) do
    []
  end

  defp handle_result(res) do
    {:ok, res}
  end
end
