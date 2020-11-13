defmodule Aicacia.Id.Web.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Plug.Conn
      import Phoenix.ConnTest
      alias Aicacia.Id.Web.Router.Helpers, as: Routes

      @endpoint Aicacia.Id.Web.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Aicacia.Id.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Aicacia.Id.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
