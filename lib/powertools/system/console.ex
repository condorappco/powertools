defmodule Powertools.System.Console do
  @moduledoc false

  @behaviour Powertools.System

  alias Powertools.UI
  alias Powertools.UI.Color

  @impl true
  def port_command(cd, command) do
    port =
      Port.open(
        {:spawn, command},
        [
          :use_stdio,
          :exit_status,
          {:cd, cd}
        ]
      )

    port
    |> stream_output()
  end

  defp stream_output(port) do
    receive do
      {^port, {:data, data}} ->
        binary_data = IO.iodata_to_binary(data)

        if String.ends_with?(binary_data, "\n") do
          binary_data
          |> String.replace_trailing("\n", "")
          |> String.split("\n")
          |> Enum.map_join("\n", fn line ->
            [
              [
                {"❯", Color.command_color()},
                line
              ]
            ]
            |> UI.format()
          end)
          |> UI.print()
        else
          input =
            IO.gets(
              [
                [
                  {"❯", Color.command_color()},
                  binary_data
                ]
              ]
              |> UI.format()
            )

          Port.command(port, input)
        end

        stream_output(port)

      {^port, {:exit_status, 0}} ->
        {:ok, :success}

      {^port, {:exit_status, exit_code}} ->
        {:error, exit_code}
    end
  end

  @impl true
  def shell_command(cd, command) do
    case System.shell(command, cd: cd, stderr_to_stdout: true) do
      {output, 0} -> {:ok, output}
      {output, _} -> {:error, output}
    end
  end
end
