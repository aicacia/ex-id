defmodule Aicacia.User.Web.View.ErrorTest do
  use Aicacia.User.Web.ConnCase, async: true

  import Phoenix.View

  test "renders 404.json" do
    assert render(Aicacia.User.Web.View.Error, "404.json", []) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500.json" do
    assert render(Aicacia.User.Web.View.Error, "500.json", []) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
