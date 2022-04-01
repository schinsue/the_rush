defmodule TheRush.Statistics.Search do
  import Ecto.Changeset

  @types %{query: :string}

  def changeset(attrs) do
    cast({%{}, @types}, attrs, [:query])
    |> validate_required([:query])
    |> validate_format(:query, ~r/[A-Za-z0-9\ ]/)
  end
end
