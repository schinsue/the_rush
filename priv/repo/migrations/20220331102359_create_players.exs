defmodule TheRush.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :team, :string
      add :position, :string
      add :att, :integer
      add :att_g, :float
      add :yds, :integer
      add :avg, :float
      add :yds_g, :float
      add :td, :integer
      add :lng, :integer
      add :lng_t, :string
      add :first_downs, :integer
      add :first_downs_pct, :float
      add :twenty_yds, :integer
      add :fourty_yds, :integer
      add :fum, :integer

      timestamps()
    end
  end
end
