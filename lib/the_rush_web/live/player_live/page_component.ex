defmodule TheRushWeb.Live.PageComponent do
  use TheRushWeb, :live_component
  import TheRushWeb.Live.TableHelpers

  @distance 10

  def render(assigns) do
    ~H"""
    <div id={assigns[:id] || "pagination"} class={"page-component"}>
      <%= if @total_pages > 1 do %>
        <div>
          <%= prev_link(@params, @page_number) %>
          <%= for num <- start_page(@page_number)..end_page(@page_number, @total_pages) do %>
            <%= live_patch num, to: "?#{querystring(@params, page: num)}", class: "#{if @page_number == num, do: "page-active", else: ""}" %>
          <% end %>
          <%= next_link(@params, @page_number, @total_pages) %>
        </div>
      <% end %>
    </div>
    """
  end

  defp page_assigns(%Scrivener.Page{} = page) do
    [
      page_number: page.page_number,
      page_size: page.page_size,
      total_entries: page.total_entries,
      total_pages: page.total_pages
    ]
  end

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(page_assigns(assigns[:pagination_data]))
    }
  end

  defp next_link(conn, current_page, num_pages) do
    if current_page != num_pages do
      live_patch("Next",
        to: "?" <> querystring(conn, page: current_page + 1)
      )
    else
      live_patch("Next", to: "#", class: "link-disabled")
    end
  end

  defp prev_link(conn, current_page) do
    if current_page != 1 do
      live_patch("Prev",
        to: "?" <> querystring(conn, page: current_page - 1)
      )
    else
      live_patch("Prev", to: "#", class: "link-disabled")
    end
  end

  defp start_page(current_page) when current_page - @distance <= 0, do: 1
  defp start_page(current_page), do: current_page - @distance

  defp end_page(current_page, 0), do: current_page

  defp end_page(current_page, total)
       when current_page <= @distance and @distance * 2 <= total do
    @distance * 2
  end

  defp end_page(current_page, total) when current_page + @distance >= total do
    total
  end

  defp end_page(current_page, _total), do: current_page + @distance - 1
end
