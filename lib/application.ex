defmodule DDNS.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      DDNS
    ]

    opts = [strategy: :one_for_one, name: DDNS.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
