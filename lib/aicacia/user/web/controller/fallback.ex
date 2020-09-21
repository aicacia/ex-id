defmodule Aicacia.User.Web.Controller.Fallback do
  use Aicacia.User.Web, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(Aicacia.User.Web.View.Changeset)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, %Ecto.NoResultsError{}}) do
    conn
    |> put_status(:not_found)
    |> put_view(Aicacia.User.Web.View.Error)
    |> render(:"404")
  end
end
