defmodule ElixirWorker do
  use Application

  def start(_type, _args) do
    ElixirWorker.Supervisor.start_link
  end
end
