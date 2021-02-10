defmodule TinyColor.Ecto.ColorTest do
  use ExUnit.Case

  @existing_rgb_color TinyColor.rgb(10, 50, 200)
  @existing_hsl_color TinyColor.hsl(10, 0.5, 0.5)

  defmodule TestSchema do
    use Ecto.Schema

    schema "users" do
      field(:color, TinyColor.Ecto.Color)
    end
  end

  test "cast" do
    {:ok, %TinyColor.RGB{}} = TinyColor.Ecto.Color.cast("#abc")
    {:ok, %TinyColor.HSL{}} = TinyColor.Ecto.Color.cast("hsl(30, 50%, 50%)")
    :error = TinyColor.Ecto.Color.cast("")
    :error = TinyColor.Ecto.Color.cast("#")
    :error = TinyColor.Ecto.Color.cast("#ab")
    {:ok, @existing_rgb_color} = TinyColor.Ecto.Color.cast(@existing_rgb_color)
    {:ok, @existing_hsl_color} = TinyColor.Ecto.Color.cast(@existing_hsl_color)
  end

  test "load" do
    {:ok, %TinyColor.RGB{}} = TinyColor.Ecto.Color.load("#abc")
    {:ok, %TinyColor.HSL{}} = TinyColor.Ecto.Color.load("hsl(30, 50%, 50%)")
  end

  test "dump" do
    assert {:ok, to_string(@existing_rgb_color)} == TinyColor.Ecto.Color.dump(@existing_rgb_color)
    assert {:ok, to_string(@existing_hsl_color)} == TinyColor.Ecto.Color.dump(@existing_hsl_color)

    assert {:ok, "rgba(255, 255, 255, 0.1111)"} ==
             TinyColor.Ecto.Color.dump(TinyColor.rgb(255, 255, 255, 0.1111111111))

    :error = TinyColor.Ecto.Color.dump(%{})
  end

  test "valid changeset" do
    changeset =
      %TestSchema{}
      |> Ecto.Changeset.cast(%{color: "#abc"}, [:color])

    assert changeset.valid?
    %Ecto.Changeset{changes: %{color: %TinyColor.RGB{}}} = changeset
  end

  test "invalid changeset" do
    changeset =
      %TestSchema{}
      |> Ecto.Changeset.cast(%{color: "#"}, [:color])

    refute changeset.valid?
    # todo: improve error handling? Add validator function?
    assert [color: {"is invalid", [type: TinyColor.Ecto.Color, validation: :cast]}] ==
             changeset.errors
  end

  test "empty changeset" do
    changeset =
      %TestSchema{}
      |> Ecto.Changeset.cast(%{color: ""}, [:color])

    assert changeset.valid?
    assert %{} == changeset.changes

    changeset_when_required = Ecto.Changeset.validate_required(changeset, [:color])
    refute changeset_when_required.valid?
  end
end
