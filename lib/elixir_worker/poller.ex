defmodule ElixirWorker.Poller do
  use GenServer

  def start_link(redis) do
    GenServer.start_link(__MODULE__, redis, [])
  end

  def init(redis) do
    {:ok, redis, 0}
  end

  def handle_info(:timeout, redis) do
    poll(redis)
  end

  def poll(redis) do
    IO.puts "Polling..."

    redis
    |> Exredis.query(["RPOP", "queue:elixir"])
    |> ElixirWorker.Worker.Supervisor.new_job

    :timer.sleep(10)

    poll(redis)
  end
end
