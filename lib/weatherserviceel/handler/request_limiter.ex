defmodule WSE.Service.RequestLimiter do
  require Logger
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # client
  def schedule_next(callback),
    do:
      Task.async(fn ->
        GenServer.call(__MODULE__, {:schedule_next}, :infinity)
        callback.()
      end)

  # server
  def init(:ok), do: Time.new(0, 0, 0, 0)

  def handle_call({:schedule_next}, _from, last_call_time) do
    next_allowed_time = Time.add(last_call_time, configured_timeout(), :millisecond)
    delta_ms = Time.diff(next_allowed_time, Time.utc_now(), :millisecond)
    # prevent infinite waiting, limit wait to 10 minutes
    delta_ms_save = rem(delta_ms, 1000 * 60 * 10)
    if delta_ms_save > 0 do
      Logger.info("RequestLimiter - next execution in #{delta_ms_save}ms")
      :timer.sleep(delta_ms_save)
    end

    now = Time.utc_now()
    {:reply, now, now}
  end

  defp configured_timeout do
    config = Application.get_env(:weatherserviceel, :app_config)

    div(
      config[:request_limiter_period_duration_in_sec] * 1000,
      config[:request_limiter_req_per_sec]
    )
  end
end
