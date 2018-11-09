defmodule ExTotp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: ExTotp.Worker.start_link(arg)
      # {ExTotp.Worker, arg},
      {DynamicSupervisor, name: ExTotp.TotpSupervisor, strategy: :one_for_one}
      # {ExTotp.Recalculate, [code: "666F6F626172"]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExTotp.Supervisor]
    {:ok, pid} = Supervisor.start_link(children, opts)

    codes = [
      [code: "666F6F626172"],
      [code: "666F6F626543"],
      [code: "666F6F629876"]
    ]

    Enum.each(
      codes,
      fn code ->
        DynamicSupervisor.start_child(
          ExTotp.TotpSupervisor,
          {ExTotp.Recalculate, code}
        )
      end
    )

    {:ok, pid}
  end
end
