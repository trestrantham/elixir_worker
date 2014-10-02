defmodule ElixirWorker.Worker.Supervisor do
  use Supervisor
  require Logger

  def start_link([redis]) do
    Logger.info "Workout Supervisor start_link"
    Supervisor.start_link(__MODULE__, {:ok, redis})
  end

  def init({:ok, redis}) do
    Logger.info "Workout Supervisor init"
    children = [
      worker(ElixirWorker.Worker, [redis])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  def new_job(:undefined) do
    Logger.info "Workout Supervisor new_job: No job."
  end

  def new_job(job) do
    Logger.info "Workout Supervisor new_job: #{job}"
    {:ok, pid} = Supervisor.start_child(__MODULE__, [])
    ElixirWorker.Worker.run(pid, job)
  end
end
