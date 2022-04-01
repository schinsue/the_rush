defmodule TheRushWeb.DownloadControllerTest do
  use TheRushWeb.ConnCase

  import TheRush.StatisticsFixtures

  describe "Generating csv" do
    setup [:create_multiple_users]

    test "POST /players/download_csv", %{conn: conn, players: players} do
      [jim, joe, _tom] = players

      json_encoded_params =
        %{"sort_direction" => "asc", "sort_field" => "name", "query" => "j"} |> Jason.encode!()

      params = %{"download_csv" => %{"params" => json_encoded_params}}

      conn = post(conn, Routes.download_path(conn, :create, params))

      # check if the response body includes jim and joe's name
      assert conn.resp_body =~ jim.name
      assert conn.resp_body =~ joe.name

      # check if response body is exactly what I expect (basically the CSV)
      assert conn.resp_body ==
               "name,team,position,att,att_g,yds,avg,yds_g,td,lng,first_downs,first_downs_pct,twenty_yds,fourty_yds,fum\r\nJim Brown,Player 1 team,Player 1 position,1,1.0,5,1.0,1.0,250,60T,1,1.0,1,1,1\r\nJoe Montana,Player 2 team,Player 2 position,2,2.0,300,2.0,2.0,300,30T,2,2.0,2,2,2\r\n"
    end
  end

  defp create_multiple_users(_) do
    players = multiple_players_fixture()
    %{players: players}
  end
end
