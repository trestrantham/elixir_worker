defmodule ElixirWorker do
  use Application
  require Logger

  def start(_type, _args) do
    Logger.info "Starting application"
    ElixirWorker.Supervisor.start_link
  end
end
