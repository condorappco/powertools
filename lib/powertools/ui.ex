defmodule Powertools.UI do
  @moduledoc false

  alias Powertools.UI.{Color, Format, Spinner, Title}

  def print(text) when is_binary(text), do: text |> IO.puts()
  def print(lines), do: Format.format(lines) |> IO.puts()

  @spec prompt(String.t()) :: String.t()
  def prompt(prompt), do: prompt(prompt, nil)

  def prompt(prompt, :underscore) do
    value = prompt(prompt, nil)

    if value |> String.replace(" ", "_") |> String.equivalent?(Macro.underscore(value)) do
      value
    else
      prompt(prompt, :underscore)
    end
  end

  def prompt(prompt, _) do
    answer = (prompt <> " ") |> IO.gets() |> String.trim()

    case(answer) do
      "" -> prompt(prompt)
      answer -> answer
    end
  end

  @spec confirm(binary) :: boolean
  def confirm(question) do
    answer = (question <> " [Yn] ") |> IO.gets() |> String.trim() |> String.downcase()

    case(answer) do
      "y" -> true
      "n" -> false
      _ -> confirm(question)
    end
  end

  # TEXT
  #
  def format(config), do: Format.format(config)

  def ansi(text, :all_colors), do: color_chars(text, Color.all_colors())
  def ansi(text, :light_colors), do: color_chars(text, Color.light_colors())
  def ansi(text, :dark_colors), do: color_chars(text, Color.dark_colors())
  def ansi(text, func), do: apply(IO.ANSI, func, []) <> text <> IO.ANSI.reset()

  def random_color(type \\ nil), do: Color.random(type)

  defp color_chars(text, colors) do
    text
    |> String.codepoints()
    |> Enum.map_join("", fn char ->
      apply(IO.ANSI, Enum.random(colors), []) <> char <> IO.ANSI.reset()
    end)
  end

  def format_dependency(name, version, installed_version, color) do
    [
      [
        {"»", [color, :bright]},
        {name, :bright},
        {version, color},
        {if(installed_version && !is_atom(installed_version),
           do: "(#{installed_version} installed)",
           else: ""
         ), [:light_black, :italic]}
      ]
    ]
    |> Format.format()
  end

  # SPINNER
  #
  def spinner(config = %Spinner{}, fun) do
    result = Spinner.run(config, fun)

    clear_line()

    case result do
      {:ok, _} -> status(:ok, config.text, config.success_text, true, :light_green)
      {:error, _} -> status(:error, config.text, config.failure_text, true, :light_red)
      _ -> status(:info, config.text, "unknown", true, :light_cyan)
    end

    result
  end

  # OUTPUTS
  #
  @spec clear_line :: :ok
  def clear_line(), do: IO.write([IO.ANSI.clear_line(), "\r"])

  @spec title(String.t(), atom()) :: :ok
  def title(text, spacing), do: Title.title(text, spacing)

  @spec title_text(String.t(), atom()) :: String.t()
  def title_text(text, spacing), do: Title.title_text(text, spacing)

  @spec status(atom, String.t(), String.t(), boolean, atom) :: :ok
  def status(status, text, status_text, icon, color),
    do: IO.puts(status_text(status, text, status_text, icon, color))

  @spec status_text(atom, String.t(), String.t(), boolean, atom) :: String.t()
  def status_text(status, text, status_text, show_icon, color) do
    icon = status_text_icon(status)

    [
      if(show_icon, do: ansi(icon, color)),
      text,
      ansi(status_text, color),
      ""
    ]
    |> Enum.reject(fn x -> is_nil(x) end)
    |> Enum.join(" ")
  end

  defp status_text_icon(:ok), do: "✔"
  defp status_text_icon(:error), do: "✖"
  defp status_text_icon(:warning), do: "!"
  defp status_text_icon(:info), do: "✔"
  defp status_text_icon(icon), do: icon

  # FOOTER
  #
  @spec footer :: :ok
  def footer() do
    [
      "",
      "\\=======-.  ,~\\ .-=======/" |> ansi(:all_colors),
      "  \\=======\\_||_/=======/" |> ansi(:all_colors),
      "     \\\\=====##=====//" |> ansi(:all_colors),
      "           \\##/" |> ansi(:all_colors),
      "           /||\\  " |> ansi(:all_colors)
    ]
    |> print()
  end
end
