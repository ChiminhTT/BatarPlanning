defmodule BatarPlanning.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :friday, :boolean, default: false
    field :monday, :boolean, default: false
    field :name, :string
    field :saturday, :boolean, default: false
    field :sunday, :boolean, default: false
    field :thursday, :boolean, default: false
    field :tuesday, :boolean, default: false
    field :wednesday, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday])
    |> validate_required([:name, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday])
  end
end
