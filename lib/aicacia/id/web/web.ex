defmodule Aicacia.Id.Web do
  def controller do
    quote do
      use Phoenix.Controller, namespace: Aicacia.Id.Web

      import Plug.Conn
      import Aicacia.Id.Gettext
      alias Aicacia.Id.Web.Router.Helpers, as: Routes
    end
  end

  def plug do
    quote do
      use Phoenix.Controller, namespace: Aicacia.Id.Web
      import Plug.Conn
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/aicacia/id/web/templates",
        namespace: Aicacia.Id.Web

      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import Aicacia.Id.Gettext
    end
  end

  defp view_helpers do
    quote do
      use Phoenix.HTML

      import Phoenix.LiveView.Helpers

      import Phoenix.View

      import Aicacia.Id.Web.View.ErrorHelpers
      import Aicacia.Id.Gettext
      alias Aicacia.Id.Web.Router.Helpers, as: Routes
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
