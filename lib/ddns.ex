defmodule DDNS do
  use GenServer
  require Logger

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default)
  end

  @impl true
  def init(_state) do
    schedule_check()
    schedule_reset()

    {:ok, reset_state()}
  end

  @impl true
  def handle_info(:check, state) do
    schedule_check()

    updated_state =
      case external_ip() do
        {:ok, external_ip} ->
          Logger.info("Checking IPs")

          updated_ips =
            state
            |> Enum.reject(fn {_id, ip} -> ip == external_ip end)
            |> Enum.map(fn {id, ip} ->
              Logger.info("Updating #{id} from #{ip} to #{external_ip}")

              new_ip = update_ip_for_domain(id, external_ip)
              {id, new_ip}
            end)
            |> Map.new()

          Map.merge(state, updated_ips)

        {:error, _} ->
          Logger.error("Couldn't check IPs")

          state
      end

    {:noreply, updated_state}
  end

  @impl true
  def handle_info(:reset, _state) do
    schedule_reset()

    {:noreply, reset_state()}
  end

  defp schedule_check() do
    # in 5 seconds
    Process.send_after(self(), :check, 5 * 1000)
  end

  defp schedule_reset() do
    # in 15 minutes
    Process.send_after(self(), :reset, 15 * 60 * 1000)
  end

  defp external_ip() do
    result =
      :os.cmd('dig +short myip.opendns.com @resolver1.opendns.com')
      |> to_string()
      |> String.trim()

    if Regex.match?(~r/\b(?:\d{1,3}\.){3}\d{1,3}\b/, result),
      do: {:ok, result},
      else: {:error, "couldn't get IP"}
  end

  defp get_current_ip_for_domain(domain) do
    [zone_identifier, identifier] = String.split(domain, ":")
    {:ok, %{body: %{"result" => %{"content" => ip}}}} = Cloudflare.record(zone_identifier, identifier)
    ip
  end

  defp update_ip_for_domain(domain, ip) do
    [zone_identifier, identifier] = String.split(domain, ":")
    {:ok, %{body: %{"result" => %{"content" => ip}}}} = Cloudflare.update_record_ip(zone_identifier, identifier, ip)
    ip
  end

  defp reset_state() do
    Application.get_env(:ddns, :domains)
    |> String.split(",")
    |> Enum.map(&{&1, get_current_ip_for_domain(&1)})
    |> Map.new()
  end
end
