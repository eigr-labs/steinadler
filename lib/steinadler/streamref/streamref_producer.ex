defmodule Steinadler.StreamRef.Producer do
  @moduledoc false
  use GenStage

  @impl true
  def init(state), do: {:producer, state}

  @impl true
  def handle_demand(demand, %{buffer: buffer} = state) do
    if Enum.count(buffer) >= demand do
      %{queue: queue, items: items} =
        Enum.reduce(1..demand, %{queue: buffer, items: []}, fn _, acc ->
          {{:value, item}, buff} = Qex.pop(buffer)

          acc = Map.put(acc, :queue, buff)
          Map.put(acc, :items, Map.get(acc, :items) ++ [item])
        end)

      {:noreply, items, %{state | buffer: queue}}
    else
      IO.inspect(buffer, label: "Queue")
      items = Enum.to_list(buffer)
      {:noreply, items, %{state | buffer: Qex.new([])}}
    end
  end

  @impl true
  def handle_cast({:add, events}, %{buffer: buffer} = state) when is_list(events) do
    buf = Qex.join(buffer, Qex.new(events))
    {:noreply, Enum.to_list(buf), state}
  end

  def handle_cast({:add, events}, %{buffer: buffer} = state) do
    new_state = Qex.push(buffer, events)

    {:noreply, Enum.to_list(new_state), state}
  end

  def start_link(%{refname: name} = state) do
    state = Map.put(state, :buffer, Qex.new())
    GenStage.start_link(__MODULE__, state, name: via(name))
  end

  def add(name, events), do: GenStage.cast(via(name), {:add, events})

  defp via(name) do
    {:via, Registry, {Steinadler.Registry, {__MODULE__, name}}}
  end
end
