defmodule TheRush.Statistics.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :att, :integer
    field :att_g, :float
    field :avg, :float
    field :first_downs, :integer
    field :first_downs_pct, :float
    field :fourty_yds, :integer
    field :fum, :integer
    field :lng, :string
    field :name, :string
    field :position, :string
    field :td, :integer
    field :team, :string
    field :twenty_yds, :integer
    field :yds, :integer
    field :yds_g, :float

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :team, :position, :att, :att_g, :yds, :avg, :yds_g, :td, :lng, :first_downs, :first_downs_pct, :twenty_yds, :fourty_yds, :fum])
    |> validate_required([:name, :team, :position, :att, :att_g, :yds, :avg, :yds_g, :td, :lng, :first_downs, :first_downs_pct, :twenty_yds, :fourty_yds, :fum])
  end
end
