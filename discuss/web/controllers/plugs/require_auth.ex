defmodule Discuss.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller
  import Discuss.Router.Helpers

  def init(_) do
  end

  def call(conn, _state) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in.")
      |> redirect(to: topic_path(conn, :index))
      |> halt()
    end
  end
end
