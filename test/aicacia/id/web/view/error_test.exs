defmodule Aicacia.Id.Web.View.ErrorTest do
  use Aicacia.Id.Web.Case, async: true

  import Phoenix.View

  test "renders 401.json" do
    assert render(Aicacia.Id.Web.View.Error, "401.json", []) == %{
             errors: %{detail: "Unauthorized"}
           }
  end

  test "renders 404.json" do
    assert render(Aicacia.Id.Web.View.Error, "404.json", []) == %{
             errors: %{detail: "Not Found"}
           }
  end

  test "renders 500.json" do
    assert render(Aicacia.Id.Web.View.Error, "500.json", []) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
