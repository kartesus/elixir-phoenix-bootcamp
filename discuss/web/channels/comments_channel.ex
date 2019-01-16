defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel

  alias Discuss.{Topic, Comment}

  def join("comments:" <> id, _auth_msg, socket) do
    topic =
      Topic
      |> Repo.get(String.to_integer(id))
      |> Repo.preload(comments: [:user])

    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in("comments:new", %{"content" => content}, socket) do
    topic = socket.assigns.topic

    changeset =
      topic
      |> build_assoc(:comments, user_id: socket.assigns.user_id)
      |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:added", %{comment: comment})
        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, changeset}, socket}
    end
  end
end
