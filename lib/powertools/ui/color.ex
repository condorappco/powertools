defmodule Powertools.UI.Color do
  @moduledoc false

  def dark_colors do
    [
      :blue,
      :cyan,
      :green,
      :magenta,
      :red,
      :yellow
    ]
  end

  def light_colors do
    [
      :light_blue,
      :light_cyan,
      :light_green,
      :light_magenta,
      :light_red,
      :light_yellow
    ]
  end

  def all_colors, do: dark_colors() ++ light_colors()

  def command_color do
    light_colors()
    |> Enum.reject(fn c -> Enum.member?([:light_red, :light_green], c) end)
    |> Enum.random()
  end

  def random(:red), do: [:red, :light_red, :light_red] |> Enum.random()
  def random(:green), do: [:green, :light_green, :light_green] |> Enum.random()
  def random(:all_colors), do: all_colors() |> Enum.random()
  def random(:light_colors), do: light_colors() |> Enum.random()
  def random(:dark_colors), do: dark_colors() |> Enum.random()

  def random(:command),
    do: [:light_cyan, :light_magenta, :light_yellow, :light_blue] |> Enum.random()

  def random(_), do: random(:all_colors)
end
