defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  plug(Ueberauth)

  alias Discuss.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user = %{
      email: auth.info.email,
      provider: "github",
      token: auth.credentials.token,
      name: auth.info.name,
      nickname: auth.info.nickname
    }

    changeset = User.changeset(%User{}, user)
    signin(conn, changeset)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: topic_path(conn, :index))
  end

  defp signin(conn, changeset) do
    case insert_or_update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Login successful")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))

      {:error, reason} ->
        IO.inspect(reason)

        conn
        |> put_flash(:error, "Login failed")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  defp insert_or_update(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil -> Repo.insert(changeset)
      user -> {:ok, user}
    end
  end
end
