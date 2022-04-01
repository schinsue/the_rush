defmodule TheRushWeb.Live.TableHelpers do
  import Phoenix.LiveView.Helpers

  def sort(%{"sort_field" => field, "sort_direction" => direction})
      when direction in ~w(asc desc) do
    {String.to_atom(direction), String.to_existing_atom(field)}
  end

  # Load default list if no sorting params available
  def sort(_), do: nil

  # Create table header link
  def header_link(params, text, field) do
    direction = params["sort_direction"]

    opts =
      if params["sort_field"] == to_string(field) do
        [
          sort_field: field,
          sort_direction: reverse(direction)
        ]
      else
        [
          sort_field: field,
          sort_direction: "desc"
        ]
      end

    live_patch(text,
      to: "?" <> querystring(params, opts)
    )
  end

  # This is for pagination and query string generation
  def querystring(params, opts) do
    params = params |> Plug.Conn.Query.encode() |> URI.decode_query()

    opts = %{
      # For the pagination
      "page" => opts[:page],
      "sort_field" => opts[:sort_field] || params["sort_field"] || nil,
      "sort_direction" => opts[:sort_direction] || params["sort_direction"] || nil
    }

    params
    |> Map.merge(opts)
    |> Enum.filter(fn {_, v} -> v != nil end)
    |> Enum.into(%{})
    |> URI.encode_query()
  end

  defp reverse("desc"), do: "asc"
  defp reverse(_), do: "desc"
end
