defmodule Powertools.Utils do
  @moduledoc false

  def command_from_module(module),
    do: module |> to_string() |> String.split(".") |> List.last() |> Macro.underscore()

  def parse_version(version) when is_binary(version) do
    parts = version |> String.split(".")

    case length(parts) do
      1 -> Enum.join(parts ++ ["0", "0"], ".")
      2 -> Enum.join(parts ++ ["0"], ".")
      _ -> version
    end
  end

  def parse_version(_), do: nil

  def compare_versions(raw_value, requirement) do
    if Version.match?(parse_version(raw_value), parse_version(requirement)) do
      true
    else
      raw_value
    end
  end

  def paragraph(string, max_line_length) do
    [word | rest] = String.split(string, ~r/\s+/, trim: true)

    lines_assemble(rest, max_line_length, String.length(word), word, [])
    |> Enum.join("\n")
  end

  defp lines_assemble([], _, _, line, acc), do: [line | acc] |> Enum.reverse()

  defp lines_assemble([word | rest], max, line_length, line, acc) do
    if line_length + 1 + String.length(word) > max do
      lines_assemble(rest, max, String.length(word), word, [line | acc])
    else
      lines_assemble(rest, max, line_length + 1 + String.length(word), line <> " " <> word, acc)
    end
  end

  def calc_max_length(values) do
    Enum.reduce(values, 0, fn value, acc ->
      length = String.length(value)

      if length > acc, do: length, else: acc
    end)
  end
end
