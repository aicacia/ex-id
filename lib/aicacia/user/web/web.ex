defmodule Aicacia.User.Web do
  def controller do
    quote do
      use Phoenix.Controller, namespace: Aicacia.User.Web

      import Plug.Conn
      import Aicacia.User.Gettext
      alias Aicacia.User.Web.Router.Helpers, as: Routes
    end
  end

  def plug do
    quote do
      use Phoenix.Controller, namespace: Aicacia.User.Web
      import Plug.Conn
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/user/web/templates",
        namespace: Aicacia.User.Web

      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      import Aicacia.User.Web.View.ErrorHelpers
      import Aicacia.User.Gettext
      alias Aicacia.User.Web.Router.Helpers, as: Routes
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
      import Aicacia.User.Gettext
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
