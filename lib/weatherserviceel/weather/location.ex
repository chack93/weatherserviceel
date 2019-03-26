defmodule WSE.Weather.Location do
  use Ecto.Schema
  import Ecto.Changeset

  @collection "weatherDataEl"
  def collection, do: @collection

  @primary_key {:id, :binary_id, autogenerate: true}
  schema @collection do
    field :active, :boolean, default: false
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :active])
    |> validate_required([:name, :active])
  end
end
