defmodule TheRushWeb.PlayerLive.Index do
  use TheRushWeb, :live_view

  alias TheRush.Statistics
  alias TheRush.Statistics.Player
  alias TheRush.Statistics.Search

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Player")
    |> assign(:player, Statistics.get_player!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Player")
    |> assign(:player, %Player{})
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:params, params)
    |> assign(:players, Statistics.search_sort_players(params, params["query"]))
    |> assign(:page_title, "Listing Players")
    |> assign(:player, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    player = Statistics.get_player!(id)
    {:ok, _} = Statistics.delete_player(player)

    {:noreply, assign(socket, :players, Statistics.search_sort_players(socket.assigns.params))}
  end

  # When search bar emptied list all players
  def handle_event("search", %{"search_field" => %{"query" => ""}}, socket) do
    players = Statistics.search_sort_players(socket.assigns.params)

    {:noreply,
     socket
     |> assign(:params, Map.merge(socket.assigns.params, %{"query" => ""}))
     |> assign(:players, players)}
  end

  # filter and validate query before querying db
  def handle_event("search", %{"search_field" => query}, socket) do
    query
    |> Search.changeset()
    |> case do
      %{valid?: true, changes: %{query: query}} ->
        players = Statistics.search_sort_players(socket.assigns.params, query)

        {:noreply,
         socket
         |> assign(:params, Map.merge(socket.assigns.params, %{"query" => query}))
         |> assign(:players, players)}

      _ ->
        {:noreply, socket}
    end
  end
end
