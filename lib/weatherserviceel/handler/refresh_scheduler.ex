defmodule WSE.Service.RefreshScheduler do
  require Logger
  alias WSE.Repo.LocationRepo

  use Quantum.Scheduler,
    otp_app: :weatherserviceel

  def refresh_weather_data(force_refresh \\ false) do
    Logger.info("RefreshScheduler - refresh, force? #{force_refresh}")

    Task.start(fn ->
      refresh_condition(force_refresh)
      refresh_forecast(force_refresh)

      Logger.info("RefreshScheduler - refresh done")
    end)
  end

  def refresh_condition(force_refresh) do
    now = DateTime.utc_now()

    LocationRepo.list_weather_locations()
    |> Stream.filter(fn loc ->
      force_refresh or loc.lastConditionUpdateTs == nil or
        DateTime.diff(now, loc.lastConditionUpdateTs, :second) >
          Application.get_env(:weatherserviceel, :app_config)[:refresh_condition_interval_seconds]
    end)
    |> Enum.map(fn loc ->
      try do
        Task.await(
          WSE.Service.LocationService.location_by_id!(loc.locationId, loc.fetchLanguageKey),
          :infinity
        )
        |> Map.put(:fetchSuccessFlag, true)
      rescue
        _error in WSE.Model.Error.Internal ->
          Logger.warn("RefreshScheduler - refresh condition failed, loc-id: #{loc.locationId}")
          Map.put(loc, :fetchSuccessFlag, false)
      end
      |> (&{loc, &1}).()
    end)
    |> Enum.each(fn {old_loc, new_loc} ->
      LocationRepo.update_location(old_loc, %{
        weatherCondition: Map.from_struct(new_loc.weatherCondition || %WSE.Model.Condition{}),
        sunrise: new_loc.sunrise,
        sunset: new_loc.sunset,
        lastConditionUpdateTs: DateTime.utc_now(),
        fetchSuccessFlag: new_loc.fetchSuccessFlag
      })

      Logger.info(
        "RefreshScheduler - condition refreshed, loc-id: ${new_loc.locationId}, force? #{
          force_refresh
        }"
      )
    end)
  end

  def refresh_forecast(force_refresh) do
    now = DateTime.utc_now()

    LocationRepo.list_weather_locations()
    |> Stream.filter(fn loc ->
      force_refresh or loc.lastForecastUpdateTs == nil or
        DateTime.diff(now, loc.lastForecastUpdateTs, :second) >
          Application.get_env(:weatherserviceel, :app_config)[:refresh_forecast_interval_seconds]
    end)
    |> Enum.map(fn loc ->
      try do
        Task.await(
          WSE.Service.LocationService.forecast_by_id!(loc.locationId, loc.fetchLanguageKey),
          :infinity
        )
        |> (&{loc, &1, true}).()
      rescue
        _error in WSE.Model.Error.Internal ->
          Logger.warn("RefreshScheduler - refresh forecast failed, loc-id: #{loc.locationId}")
          {loc, [], false}
      end
    end)
    |> Enum.each(fn {loc, new_forecast, success} ->
      LocationRepo.update_location(loc, %{
        forecast: WSE.Model.Forecast.to_map(new_forecast),
        lastForecastUpdateTs: DateTime.utc_now(),
        fetchSuccessFlag: success
      })

      Logger.info(
        "RefreshScheduler - forecast refreshed, loc-id: ${loc.locationId}, force? #{force_refresh}"
      )
    end)
  end
end
