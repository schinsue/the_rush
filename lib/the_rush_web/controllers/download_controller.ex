defmodule TheRushWeb.DownloadController do
  use TheRushWeb, :controller

  alias TheRush.Statistics

  def create(conn, %{"download_csv" => %{"params" => params}}) do
    case Jason.decode(params) do
      {:ok, params} ->
        # Get all players with latest params
        players = Statistics.search_sort_all_players(params, params["query"])

        csv =
          players
          |> Enum.map(&Statistics.player_to_struct/1)
          |> generate_csv()

        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header("content-disposition", "attachment; filename=\"data.csv\"")
        |> put_root_layout(false)
        |> send_resp(200, csv)

      {:error, _} ->
        conn
        |> put_flash(:error, "Something went wrong while trying to generate csv")
        |> redirect(to: "/")
    end
  end

  # https://github.com/beatrichartz/csv
  defp generate_csv(players) do
    players
    |> CSV.encode(headers: Statistics.get_fields())
    |> Enum.to_list()
    |> to_string()
  end
end
