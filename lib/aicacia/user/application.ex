defmodule Aicacia.User.Application do
  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    children = [
      Aicacia.User.Repo,
      Aicacia.User.Web.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Aicacia.User.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Aicacia.User.Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
