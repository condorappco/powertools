defmodule Powertools.UI.Spinner do
  @moduledoc false

  use GenServer
  alias Powertools.UI

  defstruct [:text, :running_text, :success_text, :failure_text, :color]

  @frames [
    "▖",
    "▘",
    "▝",
    "▗"
  ]
  @interval 120

  # Client
  #
  def run(config = %__MODULE__{}, fun) do
    start_spinner(config)
    result = fun.()
    stop_spinner()

    result
  end

  # Server
  #
  def init(state) do
    {:ok, tick(state)}
  end

  def handle_info(:tick, state) do
    {:noreply, tick(state)}
  end

  def handle_call(:stop, _from, {config, count}) do
    {:stop, :normal, :ok, {config, count}}
  end

  # Private
  #
  defp start_spinner(config) do
    GenServer.start(__MODULE__, {config, 0}, name: :condor_spinner)
  end

  defp stop_spinner do
    if Process.whereis(:condor_spinner) do
      GenServer.call(:condor_spinner, :stop)
    else
      :ok
    end
  end

  defp tick({config, count}) do
    index = Integer.mod(count, length(@frames))
    frame = Enum.at(@frames, index)

    UI.clear_line()
    IO.write(UI.status_text(frame, config.text, config.running_text, true, config.color))

    Process.send_after(self(), :tick, @interval)

    {config, count + 1}
  end
end
