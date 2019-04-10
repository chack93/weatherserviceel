defmodule WSE.Repo.LocationRepo do
  @moduledoc """
  Weather location mongodb repo
  """
  require Logger

  import Ecto.Query, warn: false

  alias WSE.Model.Location

  @doc """
  Returns a list of all weather_locations.
  ## Examples
    iex> list_weather_locations()
    [%Location{}, ...]
  """
  def list_weather_locations, do:
    Mongo.find(:mongodb_pool, Location.collection, %{}, pool: DBConnection.Poolboy)
    |> Enum.to_list
    |> Enum.map(&map_to_schema({:ok, &1}))
    |> Enum.map(fn {:ok, el} -> el end)

  @doc """
  Check if location of locationId exists
  ## Examples
    iex> location_exists?(1234)
    true
  """
  def location_exists?(id) do
    found = Mongo.find_one(
      :mongodb_pool,
      Location.collection,
      %{"locationId" => id},
      pool: DBConnection.Poolboy
    )
    if found, do: true, else: false
  end

  @doc """
  Gets location of locationId.
  Raises `WSE.Model.Error.NotFound` if the Location does not exist.
  ## Examples
    iex> get_location!(1234)
    %Location{}
  """
  def get_location!(id) do
    found = Mongo.find_one(
      :mongodb_pool,
      Location.collection,
      %{"locationId" => id},
      pool: DBConnection.Poolboy
    )
    unless found, do: raise WSE.Model.Error.NotFound
    map_to_schema({:ok, found})
    |> (fn {:ok, el} -> el end).()
  end

  @doc """
  Creates a location & returns new location.
  ## Examples
    iex> create_location(1234)
    {:ok, %Location{}}

    #bad location
    iex> create_location(5678)
    {:error, %Ecto.Changeset{}}
  """
  def create_location(location \\ %Location{}) do
    changeset = Location.changeset(
      %Location{},
      location
      |> Map.put(:coordinate, Map.from_struct(location.coordinate))
      |> Map.put(:weatherCondition, Map.from_struct(location.weatherCondition))
      |> Map.from_struct
    )
    if changeset.valid? do
      if location_exists?(changeset.changes.locationId), do: raise WSE.Model.Error.BadRequest
      Mongo.find_one_and_replace(
        :mongodb_pool,
        Location.collection,
        %{},
        changeset.changes,
        return_document: :after,
        upsert: :true,
        pool: DBConnection.Poolboy
      )
      |> map_to_schema
    else
      {:error, changeset}
    end
  end

  @doc """
  Updates a location & returns updated location.
  ## Examples
    iex> update_location(%Location{}, %{})
    {:ok, %Location{}}

    #bad location
    iex> update_location(%Location{}, %{})
    {:error, %Ecto.Changeset{}}
  """
  def update_location(%Location{} = location, params) do
    changeset = Location.changeset(location, params)
    if changeset.valid? do
      Mongo.find_one_and_update(
        :mongodb_pool,
        Location.collection,
        %{"_id" => BSON.ObjectId.decode!(location.id)},
        %{"$set" => changeset.changes},
        return_document: :after,
        pool: DBConnection.Poolboy
      )
      |> map_to_schema
    else
      {:error, changeset}
    end
  end

  @doc """
  Deletes a Location. Returns deleted location or nil if location didn't exist.
  ## Examples
  iex> delete_location(123)
  {:ok, %Location{}}

  #bad location
  iex> delete_location(456)
  {:ok, nil}
  """
  def delete_location(location_id), do:
    Mongo.find_one_and_delete(
      :mongodb_pool,
      Location.collection,
      %{"locationId" => location_id},
      return_document: :after,
      pool: DBConnection.Poolboy
    )
    |> map_to_schema

  defp map_to_schema({:ok, nil}), do: {:ok, nil}
  defp map_to_schema({:ok, map}) do
    %{"_id" => id} = map
    map
    |> Map.delete("_id")
    |> Map.put("id", BSON.ObjectId.encode!(id))
      #%{map | "id" => BSON.ObjectId.encode!(map["_id"])}
    |> (&Ecto.Changeset.cast(%Location{}, &1, Location.__schema__(:fields))).()
    |> Ecto.Changeset.apply_changes()
    |> (&{:ok, &1}).()
  end

end
