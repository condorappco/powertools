defmodule Powertools.System do
  @moduledoc false

  alias Powertools.System
  alias Powertools.UI
  alias Powertools.UI.Color

  @callback port_command(String.t(), String.t()) :: {:ok, String.t()} | {:error, String.t()}
  @callback shell_command(String.t(), String.t()) :: {:ok, String.t()} | {:error, String.t()}

  def port_command(cd, command), do: system().port_command(cd, command)
  def port_command(command), do: system().port_command(".", command)

  def shell_command(cd, command, :print),
    do: shell_command(cd, command) |> format_shell(command)

  def shell_command(command, :print),
    do: shell_command(".", command) |> format_shell(command)

  def shell_command(cd, command), do: system().shell_command(cd, command)
  def shell_command(command), do: system().shell_command(".", command)

  # def dependencies do
  #   Application.get_env(:condor, :cli_dependencies, System.Dependency.dependencies())
  # end

  defp system do
    # Application.get_env(:condor, :cli_system, System.Console)
    System.Console
  end

  defp format_shell({status, output}, command) do
    UI.print([
      [{"$", :light_black}, {command, :bright}],
      if String.length(output) > 0 do
        [
          output
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
        ]
      else
        ""
      end
    ])

    {status, output}
  end
end
