defmodule Aicacia.User.Web.View.User do
  use Aicacia.User.Web, :view

  alias Aicacia.User.Web.View.User

  def render("index.json", %{users: users}) do
    render_many(users, User, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, User, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end
end
