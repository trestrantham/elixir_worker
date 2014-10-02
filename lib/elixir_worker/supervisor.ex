defmodule ElixirWorker.Supervisor do
  use Supervisor
  require Logger

  def start_link do
    Logger.info "Starting ElixirWorker supervisor with redis URL: #{Application.get_env(:redis, :connection_url)}"
    redis = Exredis.start_using_connection_string(Application.get_env(:redis, :connection_url))
    Supervisor.start_link(__MODULE__, [redis])
  end

  def init(redis) do
    Logger.info "Supervisor init"
    children = [
      worker(ElixirWorker.Poller, [redis]),
      supervisor(ElixirWorker.Worker.Supervisor, [redis])
    ]

    supervise(children, strategy: :one_for_all)
  end
end
