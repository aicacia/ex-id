defmodule Aicacia.Id.Application do
  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    children = [
      Aicacia.Id.Repo,
      Aicacia.Id.Web.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Aicacia.Id.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Aicacia.Id.Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
