defmodule LogflareWeb.Plugs.CheckSourceCount do
  import Plug.Conn
  import Phoenix.Controller
  import Ecto.Query, only: [from: 2]

  alias LogflareWeb.Router.Helpers, as: Routes
  alias Logflare.Repo

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = conn.assigns.user.id

    query =
      from(s in "sources",
        where: s.user_id == ^user_id,
        select: count(s.id)
      )

    sources_count = Repo.one(query)

    if sources_count < 101 do
      conn
    else
      conn
      |> put_flash(:error, "You have 100 sources. Delete one first!")
      |> redirect(to: Routes.source_path(conn, :dashboard))
      |> halt()
    end
  end
end
