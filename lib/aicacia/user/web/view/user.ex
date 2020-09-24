defmodule Aicacia.User.Web.View.User do
  use Aicacia.User.Web, :view

  alias Aicacia.User.Web.View.User
  alias Aicacia.User.Web.View.Email

  def render("index.json", %{users: users}) do
    render_many(users, User, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, User, "user.json")
  end

  def render("private_show.json", %{user: user, user_token: user_token}) do
    render_one(user, User, "private_user.json", user_token: user_token)
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end

  def render("private_user.json", %{user: user, user_token: user_token}) do
    %{
      id: user.id,
      email: render_user_email(user.emails),
      emails: render_many(user.emails, Email, "email.json"),
      token: user_token,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end

  defp render_user_email(user_emails) do
    case primary_email(user_emails) do
      nil ->
        nil

      user_email ->
        render_one(user_email, Email, "email.json")
    end
  end

  defp primary_email(user_emails) do
    case user_emails
         |> Enum.filter(fn user_email -> user_email.confirmed and user_email.primary end)
         |> Enum.at(0) do
      nil ->
        user_emails |> Enum.at(0)

      user_email ->
        user_email
    end
  end
end
