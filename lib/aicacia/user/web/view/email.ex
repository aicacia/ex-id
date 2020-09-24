defmodule Aicacia.User.Web.View.Email do
  use Aicacia.User.Web, :view

  alias Aicacia.User.Web.View.Email

  def render("index.json", %{emails: emails}), do: render_many(emails, Email, "email.json")

  def render("show.json", %{email: email}), do: render_one(email, Email, "email.json")

  def render("email.json", %{email: email}),
    do: %{
      id: email.id,
      email: email.email,
      confirmed: email.confirmed,
      primary: email.primary,
      inserted_at: email.inserted_at,
      updated_at: email.updated_at
    }
end
