defmodule TheRush.Seed.Helper do
  def sanitize_integer(integer) do
    {int, _} =
      "#{integer}"
      |> String.replace(",", "")
      |> Integer.parse()

    int
  end

  def sanitize_float(float) do
    {float, _} =
      "#{float}"
      |> Float.parse()

    float
  end

  def sanitize_string(string), do: "#{string}"
end

alias TheRush.Statistics.Player
alias TheRush.Repo
alias TheRush.Seed.Helper

# Clean database before seeding
Repo.delete_all(Player)

# Read json file and insert players
# Sanitize and create changeset for validation
File.read!("./priv/repo/rushing.json")
|> Jason.decode!()
|> Enum.each(fn player ->
  %Player{}
  |> Player.changeset(%{
    att: Helper.sanitize_integer(player["Att"]),
    att_g: Helper.sanitize_float(player["Att/G"]),
    avg: Helper.sanitize_float(player["Avg"]),
    first_downs: Helper.sanitize_integer(player["1st"]),
    first_downs_pct: Helper.sanitize_float(player["1st%"]),
    fourty_yds: Helper.sanitize_integer(player["40+"]),
    fum: Helper.sanitize_integer(player["FUM"]),
    lng: Helper.sanitize_string(player["Lng"]),
    name: Helper.sanitize_string(player["Player"]),
    position: Helper.sanitize_string(player["Pos"]),
    td: Helper.sanitize_integer(player["TD"]),
    team: Helper.sanitize_string(player["Team"]),
    twenty_yds: Helper.sanitize_integer(player["20+"]),
    yds: Helper.sanitize_integer(player["Yds"]),
    yds_g: Helper.sanitize_float(player["Yds/G"])
  })
  |> Repo.insert!()
end)
