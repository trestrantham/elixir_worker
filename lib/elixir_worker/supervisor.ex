defmodule ElixirWorker.Supervisor do
  use Supervisor

  def start_link do
    redis = Exredis.start_using_connection_string(Application.get_env(:redis, :connection_url))
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
