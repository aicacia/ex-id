defmodule Aicacia.User.Web.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ConnTest
      alias Aicacia.User.Web.Router.Helpers, as: Routes

      @endpoint Aicacia.User.Web.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Aicacia.User.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Aicacia.User.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
