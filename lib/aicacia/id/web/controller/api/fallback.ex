defmodule Aicacia.Id.Web.Controller.Api.Fallback do
  use Aicacia.Id.Web, :controller

  alias Aicacia.Id.Web.View

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(View.Changeset)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, %Ecto.InvalidChangesetError{changeset: changeset}}) do
    call(conn, {:error, changeset})
  end

  def call(conn, {:error, %Ecto.NoResultsError{}}) do
    conn
    |> put_status(:not_found)
    |> put_view(View.Error)
    |> render(:"404")
  end
end
