defmodule ElixirWorker.Supervisor do
  use Supervisor

  def start_link do
    {:ok, redis} = Exredis.start_link
    Supervisor.start_link(__MODULE__, {:ok, redis})
  end

  def init({:ok, redis}) do
    children = [
      worker(ElixirWorker.Poller, redis),
      supervisor(ElixirWorker.Worker.Supervisor, redis)
    ]

    supervise(children, strategy: :one_for_all)
  end
end
