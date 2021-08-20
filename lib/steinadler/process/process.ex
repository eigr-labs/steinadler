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
  def handle_call({:handle, _request}, _from, state) do
    {:reply, :ok, state}
  end

  @spec handle(Steinadler.Dist.Protocol.ProcessRequest.t()) :: any
  def handle(%ProcessRequest{} = request) do
    GenServer.call(__MODULE__, {:handle, request})
  end
end
