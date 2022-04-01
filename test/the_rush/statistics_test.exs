defmodule TheRush.StatisticsTest do
  use TheRush.DataCase

  alias TheRush.Statistics

  describe "players" do
    alias TheRush.Statistics.Player

    import TheRush.StatisticsFixtures

    @invalid_attrs %{
      att: nil,
      att_g: nil,
      avg: nil,
      first_downs: nil,
      first_downs_pct: nil,
      fourty_yds: nil,
      fum: nil,
      lng: nil,
      name: nil,
      position: nil,
      td: nil,
      team: nil,
      twenty_yds: nil,
      yds: nil,
      yds_g: nil
    }

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Statistics.list_players() == [player]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Statistics.get_player!(player.id) == player
    end

    test "create_player/1 with valid data creates a player" do
      valid_attrs = %{
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
      }

      assert {:ok, %Player{} = player} = Statistics.create_player(valid_attrs)
      assert player.att == 42
      assert player.att_g == 120.5
      assert player.avg == 120.5
      assert player.first_downs == 42
      assert player.first_downs_pct == 120.5
      assert player.fourty_yds == 42
      assert player.fum == 42
      assert player.lng == 42
      assert player.lng_t == "some lng_t"
      assert player.name == "some name"
      assert player.position == "some position"
      assert player.td == 42
      assert player.team == "some team"
      assert player.twenty_yds == 42
      assert player.yds == 42
      assert player.yds_g == 120.5
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Statistics.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()

      update_attrs = %{
        att: 43,
        att_g: 456.7,
        avg: 456.7,
        first_downs: 43,
        first_downs_pct: 456.7,
        fourty_yds: 43,
        fum: 43,
        lng: 43,
        lng_t: "some updated lng_t",
        name: "some updated name",
        position: "some updated position",
        td: 43,
        team: "some updated team",
        twenty_yds: 43,
        yds: 43,
        yds_g: 456.7
      }

      assert {:ok, %Player{} = player} = Statistics.update_player(player, update_attrs)
      assert player.att == 43
      assert player.att_g == 456.7
      assert player.avg == 456.7
      assert player.first_downs == 43
      assert player.first_downs_pct == 456.7
      assert player.fourty_yds == 43
      assert player.fum == 43
      assert player.lng == 43
      assert player.lng_t == "some updated lng_t"
      assert player.name == "some updated name"
      assert player.position == "some updated position"
      assert player.td == 43
      assert player.team == "some updated team"
      assert player.twenty_yds == 43
      assert player.yds == 43
      assert player.yds_g == 456.7
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Statistics.update_player(player, @invalid_attrs)
      assert player == Statistics.get_player!(player.id)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Statistics.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Statistics.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Statistics.change_player(player)
    end

    test "searching a player name returns the right players" do
      [_jim, _joe, tom] = multiple_players_fixture()
      %{entries: result} = Statistics.search_sort_players(%{}, "Tom brady")
      [player_result] = result
      assert tom.name == player_result.name
    end

    test "searching and sorting a player returns the right players" do
      [jim, joe, _tom] = multiple_players_fixture()
      params = %{"sort_direction" => "desc", "sort_field" => "name", "query" => "j"}
      %{entries: result} = Statistics.search_sort_players(params, params["query"])
      [result1, result2] = result
      assert joe.name == result1.name
      assert jim.name == result2.name
    end

    test "sorting total rushing yards in ascending order returns the right players in order" do
      [jim, joe, tom] = multiple_players_fixture()
      params = %{"sort_direction" => "asc", "sort_field" => "yds"}
      %{entries: result} = Statistics.search_sort_players(params)
      [result1, result2, result3] = result
      assert jim.name == result1.name
      assert tom.name == result2.name
      assert joe.name == result3.name
    end

    test "sorting total rushing yards in descending order returns the right players in order" do
      [jim, joe, tom] = multiple_players_fixture()
      params = %{"sort_direction" => "desc", "sort_field" => "yds"}
      %{entries: result} = Statistics.search_sort_players(params)
      [result1, result2, result3] = result
      assert jim.name == result3.name
      assert tom.name == result2.name
      assert joe.name == result1.name
    end

    test "sorting longest rush in ascending order returns the right players in order" do
      [jim, joe, tom] = multiple_players_fixture()
      params = %{"sort_direction" => "asc", "sort_field" => "lng"}
      %{entries: result} = Statistics.search_sort_players(params)
      [result1, result2, result3] = result
      assert jim.name == result2.name
      assert joe.name == result1.name
      assert tom.name == result3.name
    end

    test "sorting longest rush in descending order returns the right players in order" do
      [jim, joe, tom] = multiple_players_fixture()
      params = %{"sort_direction" => "desc", "sort_field" => "lng"}
      %{entries: result} = Statistics.search_sort_players(params)
      [result1, result2, result3] = result
      assert jim.name == result2.name
      assert joe.name == result3.name
      assert tom.name == result1.name
    end

    test "sorting total rushing touchdowns in ascending order returns the right players in order" do
      [jim, joe, tom] = multiple_players_fixture()
      params = %{"sort_direction" => "asc", "sort_field" => "td"}
      %{entries: result} = Statistics.search_sort_players(params)
      [result1, result2, result3] = result
      assert jim.name == result1.name
      assert joe.name == result2.name
      assert tom.name == result3.name
    end

    test "sorting total rushing touchdown in descending order returns the right players in order" do
      [jim, joe, tom] = multiple_players_fixture()
      params = %{"sort_direction" => "desc", "sort_field" => "td"}
      %{entries: result} = Statistics.search_sort_players(params)
      [result1, result2, result3] = result
      assert jim.name == result3.name
      assert joe.name == result2.name
      assert tom.name == result1.name
    end

    test "Player gets converted to struct correctly for csv" do
      [jim, _joe, _tom] = multiple_players_fixture()
      converted_struct = Statistics.player_to_struct(jim)

      assert converted_struct == %{
               att: 1,
               att_g: 1.0,
               avg: 1.0,
               first_downs: 1,
               first_downs_pct: 1.0,
               fourty_yds: 1,
               fum: 1,
               lng: "60T",
               name: "Jim Brown",
               position: "Player 1 position",
               td: 250,
               team: "Player 1 team",
               twenty_yds: 1,
               yds: 5,
               yds_g: 1.0
             }
    end
  end
end
