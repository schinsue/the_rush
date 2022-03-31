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
        lng: "some lng",
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
end
