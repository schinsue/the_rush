# TheRush

## Instructions

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup` (This should also ingests rushing.json)
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
  * Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
  
## Explanation

  Everything except the download controller is using LiveView (the download controller is used to generate and send csv).

  * Webapp was generated using phoenix. Therefore some of the crud actions like create/update/delete are boilerplate code.
  * `mix ecto.setup` ingests the data using the seed helper in `priv/repo/seeds.exs`, it reads the rushing.json file provided.
  * The seed file also sanitizes the data.
  * The table is sortable by all fields (even though the requirement was only Total Rushing Yards, Longest Rush and Total Rushing Touchdowns)
  * The tests only test the sorting fields that were the requirement, but the sorting logic is the same (so it will work for all fields). I didn't want to clutter the tests by testing every single field.
  * The user can filter by player's name by using the search box. It's using a debounce parameter, so the firing rate is configurable.
  * The search is using it's own changeset (against SQL injections).
  * User can download the csv, csv will be filtered and sorted. Note that it queries all users. So if you sort on team, it might give the result back in a different order (but it's still sorted by team name).
  * Pagination was used to support larger data sets, page size is 100 now. But this is also configurable. You can still download all users through csv without scrolling to all pages.
  * Everything is tested.
  
## Most important files

  All paths are started from project root

  * `priv/repo/seeds.exs`
  * `lib/the_rush_web/controllers/download_controller.ex`
  * `lib/the_rush_web/live/player_live/index.ex`
  * `lib/the_rush_web/live/player_live/index.html.heex`
  * `lib/the_rush/statistics.ex`
  * `lib/the_rush/statistics/player.ex`
  * `lib/the_rush/statistics/search.ex`
  * `lib/the_rush_web/live/player_live/page_component.ex`
  * `lib/the_rush_web/live/table_helpers.ex`
  * `test/the_rush_web/live/player_live_test.exs`
  * `test/the_rush/statistics_test.exs`
  * `test/support/fixtures/statistics_fixtures.ex`
  * `test/the_rush_web/controllers/download_controller_test.exs`
