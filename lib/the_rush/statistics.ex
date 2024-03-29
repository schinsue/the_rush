defmodule TheRush.Statistics do
  @moduledoc """
  The Statistics context.
  """

  import Ecto.Query, warn: false
  alias TheRush.Repo

  alias TheRush.Statistics.Player

  import TheRushWeb.Live.TableHelpers, only: [sort: 1]

  @doc """
  Returns the list of players.

  ## Examples

      iex> list_players()
      [%Player{}, ...]

  """
  def list_players do
    Repo.all(Player)
  end

  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(id), do: Repo.get!(Player, id)

  @doc """
  Creates a player.

  ## Examples

      iex> create_player(%{field: value})
      {:ok, %Player{}}

      iex> create_player(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player(attrs \\ %{}) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a player.

  ## Examples

      iex> update_player(player, %{field: new_value})
      {:ok, %Player{}}

      iex> update_player(player, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player(%Player{} = player, attrs) do
    player
    |> Player.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a player.

  ## Examples

      iex> delete_player(player)
      {:ok, %Player{}}

      iex> delete_player(player)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player(%Player{} = player) do
    Repo.delete(player)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player changes.

  ## Examples

      iex> change_player(player)
      %Ecto.Changeset{data: %Player{}}

  """
  def change_player(%Player{} = player, attrs \\ %{}) do
    Player.changeset(player, attrs)
  end

  # Search and sort and return all players
  # Strictly for CSV download
  def search_sort_all_players(params, query \\ "") do
    search_sort_query(params, query)
    |> Repo.all()
  end

  # Paginated search and sort
  def search_sort_players(params, query \\ "") do
    search_sort_query(params, query)
    |> Repo.paginate(params)
  end

  # CSV needs normalized structs
  def player_to_struct(player, fields \\ get_fields()) do
    player
    |> Map.from_struct()
    # Add the Touchdown to LNG
    |> Map.update!(:lng, fn lng -> "#{lng}#{player.lng_t}" end)
    |> Map.take(fields)
  end

  # Decide which fields we want to include in CSV
  def get_fields() do
    [
      :name,
      :team,
      :position,
      :att,
      :att_g,
      :yds,
      :avg,
      :yds_g,
      :td,
      :lng,
      :first_downs,
      :first_downs_pct,
      :twenty_yds,
      :fourty_yds,
      :fum
    ]
  end

  defp search_sort_query(params, query) do
    from(
      p in Player,
      where: ilike(p.name, ^"%#{query}%"),
      order_by: ^sort(params)
    )
  end
end
