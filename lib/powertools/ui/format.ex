defmodule Powertools.UI.Format do
  @moduledoc false

  alias Powertools.{UI, Utils}

  def format(lines), do: format(:line, lines, [])

  defp format(type, {text, mods}, output) when is_binary(text) and is_list(mods) do
    format(type, [{text, mods}], output)
  end

  defp format(type, [{text, mods} | lines], output) when is_binary(text) and is_list(mods) do
    formatted =
      mods
      |> Enum.reduce(text, fn mod, acc -> acc |> UI.ansi(mod) end)

    formatted =
      if type == :line do
        Utils.paragraph(formatted, 80)
      else
        formatted
      end

    format(type, lines, output ++ [formatted])
  end

  defp format(type, [{text, mods} | lines], output) when is_binary(text) do
    format(type, [{text, [mods]} | lines], output)
  end

  defp format(type, [line | lines], output),
    do: format(type, lines, output ++ [format(:word, line, [])])

  defp format(type, line, output) when is_binary(line), do: format(type, [], output ++ [line])

  defp format(:line, [], output), do: output |> Enum.join("\n")
  defp format(:word, [], output), do: output |> Enum.join(" ")
end
