defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  plug(Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete])
  plug(:check_topic_owner when action in [:edit, :update, :delete])

  def show(conn, %{"id" => id}) do
    topic = Repo.get!(Topic, id)
    render(conn, "show.html", topic: topic)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    changeset =
      conn.assigns.user
      |> build_assoc(:topics)
      |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, record} ->
        conn
        |> put_flash(:info, "Topic '#{record.title}' Created")
        |> redirect(to: topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render(conn, "index.html", topics: topics)
  end

  def edit(conn, _params) do
    topic = conn.assigns.topic
    changeset = Topic.changeset(topic, %{})
    render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  def update(conn, %{"topic" => topic_update}) do
    topic = conn.assigns.topic
    changeset = Topic.changeset(topic, topic_update)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Topic updated")
        |> redirect(to: topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, topic: topic)
    end
  end

  def delete(conn, _params) do
    topic = conn.assigns.topic
    Repo.delete!(topic)

    conn
    |> put_flash(:info, "Topic '#{topic.title}' deleted")
    |> redirect(to: topic_path(conn, :index))
  end

  defp check_topic_owner(conn, _) do
    topic = Repo.get(Topic, conn.params["id"])
    user = conn.assigns.user

    cond do
      user && topic && user.id == topic.user_id ->
        conn
        |> assign(:topic, topic)

      true ->
        conn
        |> put_flash(:error, "You're not allowed to do it!")
        |> redirect(to: topic_path(conn, :index))
        |> halt()
    end
  end
end
