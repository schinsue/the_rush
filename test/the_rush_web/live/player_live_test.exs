defmodule TheRushWeb.PlayerLiveTest do
  use TheRushWeb.ConnCase

  import Phoenix.LiveViewTest
  import TheRush.StatisticsFixtures

  @create_attrs %{
    att: 42,
    att_g: 120.5,
    avg: 120.5,
    first_downs: 42,
    first_downs_pct: 120.5,
    fourty_yds: 42,
    fum: 42,
    lng: 42,
    lng_t: "some updated lng",
    name: "some name",
    position: "some position",
    td: 42,
    team: "some team",
    twenty_yds: 42,
    yds: 42,
    yds_g: 120.5
  }
  @update_attrs %{
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

  defp create_player(_) do
    player = player_fixture()
    %{player: player}
  end

  defp create_multiple_players(_) do
    players = multiple_players_fixture()
    %{players: players}
  end

  describe "Index" do
    setup [:create_player]

    test "lists all players", %{conn: conn, player: player} do
      {:ok, _index_live, html} = live(conn, Routes.player_index_path(conn, :index))

      assert html =~ "Listing Players"
      assert html =~ player.lng_t
    end

    test "saves new player", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.player_index_path(conn, :index))

      assert index_live |> element("a", "New Player") |> render_click() =~
               "New Player"

      assert_patch(index_live, Routes.player_index_path(conn, :new))

      assert index_live
             |> form("#player-form", player: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#player-form", player: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.player_index_path(conn, :index))

      assert html =~ "Player created successfully"
      assert html =~ "some lng"
    end

    test "updates player in listing", %{conn: conn, player: player} do
      {:ok, index_live, _html} = live(conn, Routes.player_index_path(conn, :index))

      assert index_live |> element("#player-#{player.id} a", "Edit") |> render_click() =~
               "Edit Player"

      assert_patch(index_live, Routes.player_index_path(conn, :edit, player))

      assert index_live
             |> form("#player-form", player: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#player-form", player: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.player_index_path(conn, :index))

      assert html =~ "Player updated successfully"
      assert html =~ "some updated lng_t"
    end

    test "deletes player in listing", %{conn: conn, player: player} do
      {:ok, index_live, _html} = live(conn, Routes.player_index_path(conn, :index))

      assert index_live |> element("#player-#{player.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#player-#{player.id}")
    end
  end

  # Implemented table actions that need to be tested
  describe "Index table actions" do
    setup [:create_multiple_players]
    # Search filter test for existing player
    test "searching an existing player updates listing correctly", %{conn: conn, players: players} do
      [player, _, _] = players
      {:ok, index_live, _html} = live(conn, Routes.player_index_path(conn, :index))

      assert index_live
             |> form("#search-form", search_field: %{query: "Jim"})
             |> render_change() =~ player.name

      assert has_element?(index_live, "#player-#{player.id}")
    end

    # Search filter test for non-existing player
    test "searching a non-existing player updates listing correctly", %{
      conn: conn,
      players: players
    } do
      [player, _, _] = players
      {:ok, index_live, _html} = live(conn, Routes.player_index_path(conn, :index))

      refute index_live
             |> form("#search-form", search_field: %{query: "hi random name"})
             |> render_change() =~ player.name

      refute has_element?(index_live, "#player-#{player.id}")
    end

    # Sorting by name
    test "sorting by descending player name updates listing correctly", %{
      conn: conn,
      players: players
    } do
      [player1, player2, player3] = players

      {:ok, index_live, _html} =
        live(
          conn,
          Routes.player_index_path(conn, :index, %{
            "sort_direction" => "desc",
            "sort_field" => "name"
          })
        )

      items =
        index_live
        |> render()
        |> Floki.find(".player-row")
        |> Enum.map(&Floki.text(&1, sep: " "))

      [player1_result, player2_result, player3_result] = items

      # order should be turned around now in table
      assert player1_result =~ player3.name
      assert player2_result =~ player2.name
      assert player3_result =~ player1.name
    end

    test "sorting by descending player total rushing touchdowns updates listing correctly", %{
      conn: conn,
      players: players
    } do
      [player1, player2, player3] = players

      {:ok, index_live, _html} =
        live(
          conn,
          Routes.player_index_path(conn, :index, %{
            "sort_direction" => "desc",
            "sort_field" => "td"
          })
        )

      items =
        index_live
        |> render()
        |> Floki.find(".player-row")
        |> Enum.map(&Floki.text(&1, sep: " "))

      [player1_result, player2_result, player3_result] = items

      # order should be turned around now in table
      assert player1_result =~ player3.name
      assert player2_result =~ player2.name
      assert player3_result =~ player1.name
    end

    test "sorting by ascending player total rushing touchdowns updates listing correctly", %{
      conn: conn,
      players: players
    } do
      [player1, player2, player3] = players

      {:ok, index_live, _html} =
        live(
          conn,
          Routes.player_index_path(conn, :index, %{
            "sort_direction" => "asc",
            "sort_field" => "td"
          })
        )

      items =
        index_live
        |> render()
        |> Floki.find(".player-row")
        |> Enum.map(&Floki.text(&1, sep: " "))

      [player1_result, player2_result, player3_result] = items

      assert player1_result =~ player1.name
      assert player2_result =~ player2.name
      assert player3_result =~ player3.name
    end

    test "sorting by ascending player longest rush updates listing correctly", %{
      conn: conn,
      players: players
    } do
      [player1, player2, player3] = players

      {:ok, index_live, _html} =
        live(
          conn,
          Routes.player_index_path(conn, :index, %{
            "sort_direction" => "asc",
            "sort_field" => "lng"
          })
        )

      items =
        index_live
        |> render()
        |> Floki.find(".player-row")
        |> Enum.map(&Floki.text(&1, sep: " "))

      [player1_result, player2_result, player3_result] = items

      assert player1_result =~ player2.name
      assert player2_result =~ player1.name
      assert player3_result =~ player3.name
    end

    test "sorting by descending player longest rush updates listing correctly", %{
      conn: conn,
      players: players
    } do
      [player1, player2, player3] = players

      {:ok, index_live, _html} =
        live(
          conn,
          Routes.player_index_path(conn, :index, %{
            "sort_direction" => "desc",
            "sort_field" => "lng"
          })
        )

      items =
        index_live
        |> render()
        |> Floki.find(".player-row")
        |> Enum.map(&Floki.text(&1, sep: " "))

      [player1_result, player2_result, player3_result] = items

      assert player1_result =~ player3.name
      assert player2_result =~ player1.name
      assert player3_result =~ player2.name
    end

    test "sorting by descending player total rushing yards updates listing correctly", %{
      conn: conn,
      players: players
    } do
      [player1, player2, player3] = players

      {:ok, index_live, _html} =
        live(
          conn,
          Routes.player_index_path(conn, :index, %{
            "sort_direction" => "desc",
            "sort_field" => "yds"
          })
        )

      items =
        index_live
        |> render()
        |> Floki.find(".player-row")
        |> Enum.map(&Floki.text(&1, sep: " "))

      [player1_result, player2_result, player3_result] = items

      assert player1_result =~ player2.name
      assert player2_result =~ player3.name
      assert player3_result =~ player1.name
    end

    test "sorting by ascending player total rushing yards updates listing correctly", %{
      conn: conn,
      players: players
    } do
      [player1, player2, player3] = players

      {:ok, index_live, _html} =
        live(
          conn,
          Routes.player_index_path(conn, :index, %{
            "sort_direction" => "asc",
            "sort_field" => "yds"
          })
        )

      items =
        index_live
        |> render()
        |> Floki.find(".player-row")
        |> Enum.map(&Floki.text(&1, sep: " "))

      [player1_result, player2_result, player3_result] = items

      assert player1_result =~ player1.name
      assert player2_result =~ player3.name
      assert player3_result =~ player2.name
    end

    test "searching and sorting updates listing correctly", %{conn: conn, players: players} do
      [_player1, player2, player3] = players

      {:ok, index_live, _html} =
        live(
          conn,
          Routes.player_index_path(conn, :index, %{
            "query" => "t",
            "sort_direction" => "asc",
            "sort_field" => "yds"
          })
        )

      items =
        index_live
        |> render()
        |> Floki.find(".player-row")
        |> Enum.map(&Floki.text(&1, sep: " "))

      [player1_result, player2_result] = items

      assert player1_result =~ player3.name
      assert player2_result =~ player2.name
    end
  end

  describe "Show" do
    setup [:create_player]

    test "displays player", %{conn: conn, player: player} do
      {:ok, _show_live, html} = live(conn, Routes.player_show_path(conn, :show, player))

      assert html =~ "Show Player"
      assert html =~ player.lng_t
    end

    test "updates player within modal", %{conn: conn, player: player} do
      {:ok, show_live, _html} = live(conn, Routes.player_show_path(conn, :show, player))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Player"

      assert_patch(show_live, Routes.player_show_path(conn, :edit, player))

      assert show_live
             |> form("#player-form", player: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#player-form", player: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.player_show_path(conn, :show, player))

      assert html =~ "Player updated successfully"
      assert html =~ "some updated lng_t"
    end
  end
end
