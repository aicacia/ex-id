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
        root: "lib/user/web/templates",
        namespace: Aicacia.Id.Web

      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      import Aicacia.Id.Web.View.ErrorHelpers
      import Aicacia.Id.Gettext
      alias Aicacia.Id.Web.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import Aicacia.Id.Gettext
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
