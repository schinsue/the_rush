defmodule TheRush.Repo.Migrations.AddIndexesToPlayersTable do
  use Ecto.Migration

  def change do
    create index("players", [:name, :yds, :lng, :td], concurrently: false)
  end
end
