import { Socket } from "phoenix";

let socket = new Socket("/socket", { params: { token: window.userToken } });

socket.connect();

function Comments(topicId) {
  let channel = socket.channel("comments:" + topicId, {});

  channel
    .join()
    .receive("ok", renderComments)
    .receive("error", err => console.log("Unable to join", err));

  channel.on(`comments:${topicId}:added`, renderComment);

  let $content = document.querySelector("textarea");
  let $collection = document.querySelector(".collection");

  document.getElementById("addComment").addEventListener("click", () => {
    const content = $content.value;
    $content.value = "";
    $content.blur();
    channel.push("comments:new", { content });
  });

  let template = ({ content, user }) =>
    `<li class="collection-item">
        ${content}
        <div class="secondary-content">
          ${user.name}
        </div>
     </li>`;

  function renderComment({ comment }) {
    console.log(comment);
    $collection.innerHTML += template(comment);
  }

  function renderComments({ comments }) {
    console.log(comments);
    $collection.innerHTML = comments.map(template).join("");
  }
}

window.Comments = Comments;
