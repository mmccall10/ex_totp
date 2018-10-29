defmodule ExTotp.Recalculate do
  use GenServer

  def start_link(args \\ %{}) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(state) do
    get_code(state)
    schedule_recalc()
    {:ok, state}
  end

  def handle_info(:recalc, state) do
    get_code(state)
    schedule_recalc()
    {:noreply, state}
  end

  defp get_code(state) do
    token = ExTotp.generate_totp(state[:code])
    IO.puts(token)
  end

  defp schedule_recalc() do
    next_run =
      DateTime.utc_now()
      |> DateTime.to_unix()
      |> rem(30)
      |> (fn seconds -> (30 - seconds) * 1000 end).()

    Process.send_after(self(), :recalc, next_run)
  end
end
