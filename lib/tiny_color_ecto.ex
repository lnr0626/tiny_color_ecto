defmodule TinyColor.Ecto.Color do
  @moduledoc """
  Custom ecto type for representing color spaces supported by tiny color.

  Serializes the colors as css color strings with no particular guarantee of the color space used.
  """

  use Ecto.Type
  def type, do: :string

  @spec cast(String.t() | TinyColor.color()) :: {:ok, TinyColor.color()} | :error
  def cast(string) when is_binary(string) do
    case TinyColor.Parser.parse(string) do
      {:ok, color} -> {:ok, color}
      _ -> :error
    end
  end

  def cast(color = %TinyColor.RGB{}),
    do: {:ok, color}

  def cast(color = %TinyColor.HSL{}),
    do: {:ok, color}

  def cast(_),
    do: :error

  @spec load(String.t()) :: {:ok, TinyColor.color()}
  def load(string) when is_binary(string) do
    case TinyColor.Parser.parse(string) do
      {:ok, color} -> {:ok, color}
      _ -> :error
    end
  end

  @spec dump(TinyColor.color()) :: {:ok, String.t()}
  def dump(color = %TinyColor.RGB{}), do: {:ok, TinyColor.RGB.to_string(color)}
  def dump(color = %TinyColor.HSL{}), do: {:ok, TinyColor.HSL.to_string(color)}
  def dump(color = %TinyColor.HSV{}), do: {:ok, TinyColor.HSV.to_string(color)}
  def dump(_), do: :error

  def equal?(t1, t2), do: TinyColor.equal?(t1, t2)
end
