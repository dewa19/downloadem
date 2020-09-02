defmodule Downloadem.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Downloadem.Storage, []},
    ]

    opts = [strategy: :one_for_one, name: Downloadem.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
