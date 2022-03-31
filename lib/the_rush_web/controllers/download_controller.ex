defmodule TheRushWeb.DownloadController do
  use TheRushWeb, :controller

  alias TheRush.Statistics

  def create(conn, %{"download_csv" => %{"players" => players}}) do
    case Jason.decode(players) do
      {:ok, players} ->
        csv =
          players
          |> Enum.map(&convert_map_keys_to_atom/1)
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

  # fields keys and map keys need to be exactly the same for the csv...
  defp convert_map_keys_to_atom(map) do
    map
    |> Map.new(fn {k, v} -> {String.to_existing_atom(k), v} end)
  end
end
