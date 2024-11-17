defmodule Powertools.UI.Title do
  @moduledoc false

  alias Powertools.UI
  alias Powertools.UI.Format

  def title(name, spacing) do
    name
    |> title_text(spacing)
    |> IO.puts()
  end

  def title_text(text, spacing) do
    {top_row, bottom_row} =
      text
      |> String.codepoints()
      |> Enum.reverse()
      |> Enum.reduce({[], []}, fn char, {top_chars, bottom_chars} ->
        with {top_char, bottom_char} <- title_letter(char),
             top_chars <- [[{top_char, :all_colors}] |> Format.format() | top_chars],
             bottom_chars <- [[{bottom_char, :all_colors}] |> Format.format() | bottom_chars] do
          {top_chars, bottom_chars}
        else
          _ -> {top_chars, bottom_chars}
        end
      end)

    top_row = top_row |> Enum.join(" ")
    bottom_row = bottom_row |> Enum.join(" ")

    rows = [
      "",
      top_row,
      bottom_row,
      ""
    ]

    case spacing do
      :top -> Enum.slice(rows, 0..2)
      :bottom -> Enum.slice(rows, 1..3)
      :top_bottom -> rows
      _ -> Enum.slice(rows, 1..2)
    end
    |> Format.format()
  end

  # def ready_text() do
  #   [
  #     "",
  #     {"Hey, looks like you're", :green},
  #     "",
  #     "#{UI.ansi("█▀▄", UI.random_color(:green))} #{UI.ansi("██▀", UI.random_color(:green))} #{UI.ansi("▄▀▄", UI.random_color(:green))} #{UI.ansi("█▀▄", UI.random_color(:green))} #{UI.ansi("▀▄▀", UI.random_color(:green))} #{UI.ansi("█", UI.random_color(:green))}",
  #     "#{UI.ansi("█▀▄", UI.random_color(:green))} #{UI.ansi("█▄▄", UI.random_color(:green))} #{UI.ansi("█▀█", UI.random_color(:green))} #{UI.ansi("█▄▀", UI.random_color(:green))} #{UI.ansi(" █ ", UI.random_color(:green))} #{UI.ansi("▄", UI.random_color(:green))}",
  #     "",
  #     {"You are all setup to start building with condor! To start a new application, try the new command:",
  #      :green},
  #     "",
  #     [
  #       " ",
  #       {"$", :light_black},
  #       {"mix condor.new", :bright},
  #       {"<PATH>", [:bright, :light_green]}
  #     ]
  #   ]
  #   |> UI.print()
  # end

  # def not_ready_text() do
  #   [
  #     "",
  #     {"Oops, it looks like you're", :red},
  #     "",
  #     "#{UI.ansi("█▄ █", UI.random_color(:red))} #{UI.ansi("▄▀▄", UI.random_color(:red))} #{UI.ansi("▀█▀", UI.random_color(:red))}   #{UI.ansi("█▀▄", UI.random_color(:red))} #{UI.ansi("██▀", UI.random_color(:red))} #{UI.ansi("▄▀▄", UI.random_color(:red))} #{UI.ansi("█▀▄", UI.random_color(:red))} #{UI.ansi("▀▄▀", UI.random_color(:red))} #{UI.ansi(" ", UI.random_color(:red))} #{UI.ansi(" ", UI.random_color(:red))} #{UI.ansi(" ", UI.random_color(:red))}",
  #     "#{UI.ansi("█ ▀█", UI.random_color(:red))} #{UI.ansi("▀▄▀", UI.random_color(:red))} #{UI.ansi(" █ ", UI.random_color(:red))}   #{UI.ansi("█▀▄", UI.random_color(:red))} #{UI.ansi("█▄▄", UI.random_color(:red))} #{UI.ansi("█▀█", UI.random_color(:red))} #{UI.ansi("█▄▀", UI.random_color(:red))} #{UI.ansi(" █ ", UI.random_color(:red))} #{UI.ansi("▄", UI.random_color(:red))} #{UI.ansi("▄", UI.random_color(:red))} #{UI.ansi("▄", UI.random_color(:red))}",
  #     "",
  #     {"(But we'll help you get there)", :red},
  #     "",
  #     [
  #       {"Don't worry,", :red},
  #       {"there's good news!", [:light_red, :bright]},
  #       {"The setup command is our", :red},
  #       {"EASY", [:red_background, :light_white, :bright]},
  #       {"button. It will", :red}
  #     ],
  #     {"install and configure all dependencies automatically. Check it out!", :red},
  #     "",
  #     [
  #       " ",
  #       {"$", :light_black},
  #       {"mix condor.setup", :bright}
  #     ],
  #     "",
  #     {"Know what you're doing already? The missing dependencies and their versions are listed below. They can be manually installed and then checked again by rerunning this command.",
  #      :red}
  #   ]
  #   |> UI.print()
  # end

  defp title_letter(letter) when is_binary(letter) do
    %{
      "a" => {"▄▀▄", "█▀█"},
      "b" => {"█▄▄", "█▄█"},
      "c" => {"█▀▀", "█▄▄"},
      "d" => {"█▀▄", "█▄▀"},
      "e" => {"██▀", "█▄▄"},
      "f" => {"█▀▀", "█▀ "},
      "g" => {"█▀▀", "█▄█"},
      "h" => {"█▄█", "█ █"},
      "i" => {"█", "█"},
      "j" => {"  █", "█▄█"},
      "k" => {"█▄▀", "█ █"},
      "l" => {"█  ", "█▄▄"},
      "m" => {"█▀▄▀█", "█ ▀ █"},
      "n" => {"█▄ █", "█ ▀█"},
      "o" => {"█▀█", "█▄█"},
      "p" => {"█▀▄", "█▀ "},
      "q" => {"█▀█", "▀▀█"},
      "r" => {"█▀▄", "█▀▄"},
      "s" => {"▄▀▀", "▄██"},
      "t" => {"▀█▀", " █ "},
      "u" => {"█ █", "▀▄█"},
      "v" => {"█ █", "▀▄▀"},
      "w" => {"█   █", "▀▄▀▄▀"},
      "x" => {"▀▄▀", "█ █"},
      "y" => {"▀▄▀", " █ "},
      "z" => {"", ""},
      "!" => {"█", "▄"},
      "." => {" ", "▄"},
      "?" => {"▀█", " ▄"},
      " " => {" ", " "}
    }
    |> Map.get(letter |> String.downcase())
  end
end
