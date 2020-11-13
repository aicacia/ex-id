defmodule Aicacia.Id.Web.View.Username do
  use Aicacia.Id.Web, :view

  alias Aicacia.Id.Web.View.Username

  def render("show.json", %{username: username}),
    do: render_one(username, Username, "username.json")

  def render("username.json", %{username: username}),
    do: %{
      id: username.id,
      user_id: username.user_id,
      username: username.username,
      inserted_at: username.inserted_at,
      updated_at: username.updated_at
    }
end
