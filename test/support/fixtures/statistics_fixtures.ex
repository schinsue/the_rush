defmodule TheRush.StatisticsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TheRush.Statistics` context.
  """

  @doc """
  Generate a player.
  """
  def player_fixture(attrs \\ %{}) do
    {:ok, player} =
      attrs
      |> Enum.into(%{
        att: 42,
        att_g: 120.5,
        avg: 120.5,
        first_downs: 42,
        first_downs_pct: 120.5,
        fourty_yds: 42,
        fum: 42,
        lng: 42,
        lng_t: "some lng_t",
        name: "some name",
        position: "some position",
        td: 42,
        team: "some team",
        twenty_yds: 42,
        yds: 42,
        yds_g: 120.5
      })
      |> TheRush.Statistics.create_player()

    player
  end

  @doc """
  Generate multiple players.
  """
  def multiple_players_fixture() do
    players = [
      %{
        att: 1,
        att_g: 1,
        avg: 1.0,
        first_downs: 1,
        first_downs_pct: 1,
        fourty_yds: 1,
        fum: 1,
        lng: 60,
        lng_t: "T",
        name: "Jim Brown",
        position: "Player 1 position",
        td: 250,
        team: "Player 1 team",
        twenty_yds: 1,
        yds: 5,
        yds_g: 1.0
      },
      %{
        att: 2,
        att_g: 2,
        avg: 2.0,
        first_downs: 2,
        first_downs_pct: 2,
        fourty_yds: 2,
        fum: 2,
        lng: 30,
        lng_t: "T",
        name: "Joe Montana",
        position: "Player 2 position",
        td: 300,
        team: "Player 2 team",
        twenty_yds: 2,
        yds: 300,
        yds_g: 2.0
      },
      %{
        att: 3,
        att_g: 3,
        avg: 3.0,
        first_downs: 3,
        first_downs_pct: 3,
        fourty_yds: 3,
        fum: 3,
        lng: 90,
        lng_t: "T",
        name: "Tom Brady",
        position: "Player 3 position",
        td: 500,
        team: "Player 3 team",
        twenty_yds: 3,
        yds: 125,
        yds_g: 3.0
      }
    ]

    players
    |> Enum.map(fn p ->
      {:ok, player} =
        p
        |> TheRush.Statistics.create_player()

      player
    end)
    |> Enum.sort_by(& &1.name, :asc)
  end
end
