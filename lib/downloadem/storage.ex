defmodule Downloadem.Storage do
  use Agent

  def start_agent_list() do
      Agent.start_link(fn -> [] end, name: __MODULE__)
  end
  def put_to_agent_list(data) do
      Agent.update(__MODULE__, fn(state) -> state ++ data end)
  end
  def get_from_agent_list() do
      Agent.get(__MODULE__, &(&1))
  end
  def stop_agent_list() do
      Agent.stop(__MODULE__, :normal, 5000)
  end

end
