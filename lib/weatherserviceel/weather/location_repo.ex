defmodule WSE.Weather.LocationRepo do
  @moduledoc """
  The Weather context.
  """
  require Logger

  import Ecto.Query, warn: false

  alias WSE.Weather.Location

  @doc """
  Returns the list of weather_locations.

  ## Examples

      iex> list_weather_locations()
      [%Location{}, ...]

  """
  def list_weather_locations, do:
    Mongo.find(:mongodb_pool, Location.collection, %{}, pool: DBConnection.Poolboy)
    |> Enum.to_list
    |> Enum.map(&mapToSchema({:ok, &1}))
    |> Enum.map(fn {:ok, el} -> el end)

  @doc """
  Gets a single location.

  Raises `Ecto.NoResultsError` if the Location does not exist.

  ## Examples

      iex> get_location!("123")
      %Location{}

      iex> get_location!("456")
      ** (Ecto.NoResultsError)

  """
  def get_location!(id) do
    found = Mongo.find_one(
      :mongodb_pool,
      Location.collection,
      %{"_id" => BSON.ObjectId.decode!(id)},
      pool: DBConnection.Poolboy
    )
    unless found, do: raise Ecto.NoResultsError, queryable: "not found"
    found
    |> (&mapToSchema({:ok, &1})).()
    |> (fn {:ok, el} -> el end).()
  end

  @doc """
  Creates a location.

  ## Examples

      iex> create_location(%{field: value})
      {:ok, %Location{}}

      iex> create_location(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_location(attrs \\ %{}) do
    changeset = Location.changeset(%Location{}, attrs)
    if changeset.valid? do
      Mongo.find_one_and_replace(
        :mongodb_pool,
        Location.collection,
        %{},
        changeset.changes,
        return_document: :after,
        upsert: :true,
        pool: DBConnection.Poolboy
      )
      |> mapToSchema
    else
      {:error, changeset}
    end
  end

  @doc """
  Updates a location.

  ## Examples

      iex> update_location(location, %{field: new_value})
      {:ok, %Location{}}

      iex> update_location(location, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_location(%Location{} = location, attrs) do
    changeset = Location.changeset(location, attrs)
    if changeset.valid? do
      Mongo.find_one_and_update(
        :mongodb_pool,
        Location.collection,
        %{"_id" => BSON.ObjectId.decode!(location.id)},
        %{"$set" => changeset.changes},
        return_document: :after,
        pool: DBConnection.Poolboy
      )
      |> mapToSchema
    else
      {:error, changeset}
    end
  end

  @doc """
  Deletes a Location.

  ## Examples

      iex> delete_location(location)
      {:ok, %Location{}}

      iex> delete_location(location)
      {:error, %Ecto.Changeset{}}

  """
  def delete_location(%Location{} = location), do:
    Mongo.find_one_and_delete(
      :mongodb_pool,
      Location.collection,
      %{"_id" => BSON.ObjectId.decode!(location.id)},
      return_document: :after,
      pool: DBConnection.Poolboy
    )
    |> mapToSchema

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking location changes.

  ## Examples

      iex> change_location(location)
      %Ecto.Changeset{source: %Location{}}

  """
  def change_location(%Location{} = location) do
    Location.changeset(location, %{})
  end

  def mapToSchema({:ok, nil}), do: {:ok, nil}
  def mapToSchema({:ok, map}) do
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
