defmodule ElixirWorker.Worker.Supervisor do
  use Supervisor

  def start_link(redis) do
    Supervisor.start_link({:local, __MODULE__}, __MODULE__, redis)
  end

  def init(redis) do
    children = [
      worker(ElixirWorker.Worker, redis)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  def new_job(:undefined) do
    IO.puts "No job."
  end

  def new_job(job) do
    {:ok, pid} = Supervisor.start_child(__MODULE__, [])
    ElixirWorker.Worker.run(pid, job)
  end
end
