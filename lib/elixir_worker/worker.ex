defmodule ElixirWorker.Worker do
  use GenServer

  def start_link(redis) do
    :random.seed(:os.timestamp)
    GenServer.start_link(__MODULE__, redis, [])
  end

  def init(redis) do
    {:ok, redis}
  end

  def run(pid, job) do
    GenServer.cast(pid, {:run, job})
  end

  def handle_cast({:run, job}, redis) do
    IO.puts "Handling job ... #{job}"

    job         = JSON.decode!(job)
    jid         = job["jid"]
    args        = job["args"].to_i * 3
    queue       = "queue:default"
    class       = "SaveActivity"
    enqueued_at = job["enqueued_at"]

    new_job = HashDict.new
              |> HashDict.put(:queue, queue)
              |> HashDict.put(:jid, jid)
              |> HashDict.put(:class, class)
              |> HashDict.put(:args, args)
              |> HashDict.put(:enqueued_at, enqueued_at)
              |> JSON.encode!

    redis |> Exredis.query(["LPUSH", queue, new_job])

    {:noreply, redis}
  end
end
