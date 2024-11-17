defmodule Powertools.System.Dependency do
  @moduledoc false

  alias Powertools.{System, UI, Utils}

  @enforce_keys [
    :name,
    :check_command,
    :install_command,
    :setup_command,
    :version,
    :parse_version
  ]
  defstruct @enforce_keys

  # NOTICE: The order here controls the order in which the dependencies are checked/installed
  def dependencies do
    [
      %__MODULE__{
        name: "homebrew",
        check_command: "brew -v",
        install_command:
          "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"",
        setup_command: nil,
        version: "~> 3.6",
        parse_version: fn value ->
          value
          |> String.trim()
          |> String.replace("\"", "")
          |> String.split(" ")
          |> Enum.at(1)
          |> String.split("\n")
          |> Enum.at(0)
        end
      },
      %__MODULE__{
        name: "git",
        check_command: "git --version",
        install_command: nil,
        setup_command: nil,
        version: ">= 0.0.0",
        parse_version: fn value ->
          value
          |> String.trim()
          |> String.split(" ")
          |> Enum.at(2)
        end
      },
      %__MODULE__{
        name: "erlang",
        check_command:
          "erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell",
        install_command: nil,
        setup_command: nil,
        version: "~> 25",
        parse_version: fn value ->
          value
          |> String.trim()
          |> String.replace("\"", "")
        end
      },
      %__MODULE__{
        name: "elixir",
        check_command: "elixir --version | grep Elixir",
        install_command: "mix archive.install hex phx_new \"~> 1.14\" --force",
        setup_command: nil,
        version: "~> 1.14",
        parse_version: fn value ->
          value
          |> String.trim()
          |> String.replace("\"", "")
          |> String.split(" ")
          |> Enum.at(1)
        end
      },
      %__MODULE__{
        name: "phoenix",
        check_command: "mix phx.new -v",
        install_command: "mix archive.install hex phx_new \"~> 1.7.3\" --force",
        setup_command: nil,
        version: "~> 1.7.3",
        parse_version: fn value ->
          value
          |> String.trim()
          |> String.replace("\"", "")
          |> String.split(" ")
          |> Enum.at(2)
          |> String.replace_prefix("v", "")
        end
      },
      %__MODULE__{
        name: "postgresql",
        check_command: "pg_config --version",
        install_command: nil,
        setup_command: nil,
        version: ">= 14",
        parse_version: fn value ->
          value
          |> String.trim()
          |> String.replace("\"", "")
          |> String.split(" ")
          |> Enum.at(1)
        end
      }
    ]
  end

  def check(dep) do
    with {:ok, output} <- System.shell_command(dep.check_command),
         raw_value <- dep.parse_version.(output) do
      case Utils.compare_versions(raw_value, dep.version) do
        true -> {:ok, raw_value}
        _ -> {:error, raw_value}
      end
    else
      _ -> {:error, :shell}
    end
  end

  def install(dep) do
    pretty_dep = "#{dep.name |> UI.ansi(:bright)} #{dep.version |> UI.ansi(:light_black)}"

    case System.port_command(dep.install_command) do
      {:ok, _} ->
        IO.puts("")
        UI.status(:ok, pretty_dep, "installed", true, :light_green)
        {:ok, :installed}

      {:error, exit_code} when is_number(exit_code) ->
        IO.puts("")
        UI.status(:error, pretty_dep, "install exited with #{exit_code}", true, :light_red)
        {:error, exit_code}

      _ ->
        IO.puts("")
        UI.status(:error, pretty_dep, "not installed", true, :light_cyan)
        {:error, :error}
    end
  end
end
