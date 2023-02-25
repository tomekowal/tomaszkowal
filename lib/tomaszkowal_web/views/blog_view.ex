defmodule TomaszkowalWeb.BlogView do
  use TomaszkowalWeb, :view

  @tags %{
    "nix" => %{background: "#DDEBF1", color: "#111"},
    "elixir" => %{background: "#6A4B79", color: "#eee"},
    "phoenix" => %{background: "#FF6F61", color: "#eee"},
    "liveview" => %{background: "#FF6F61", color: "#eee"},
    "soft-skills" => %{background: "#BDF9FF", color: "#111"}
  }

  def color_tags(tags) do
    (for tag <- tags, do: [color_tag(tag), " "])
  end

  # I like Notion colors https://optemization.com/notion-color-guide
  # defp color_tag("nix"), do: "<a style=\"background: #DDEBF1;\" href=\"?tag=nix\">nix</a>"
  # defp color_tag("elixir"), do: "<a style=\"background: #6A4b79; color: #eee;\">elixir</a>"
  # defp color_tag("phoenix"), do: "<a style=\"background: #FF6F61; color: #eee\">phoenix</a>"
  # defp color_tag("liveview"), do: "<a style=\"background: #FF6F61; color: #eee\">liveview</a>"
  # defp color_tag("soft-skills"), do: "<a style=\"background: #BDF9FF; color: #111\">soft-skills</a>"
  defp color_tag(tag), do: link(tag, to: "?tag=#{tag}", style: "background: #{@tags[tag].background}; color: #{@tags[tag].color}")

  # add anchors to allow linking to subheaders
  def postprocess({h, [], [text], %{}}) when h in ["h1", "h2", "h3", "h4", "h5", "h6"] do
    anchor_id = text |> String.downcase() |> String.replace(~r/[^a-z]+/, "-") |> String.trim("-")
    {h, [{"id", anchor_id}], [text], %{}}
  end

  def postprocess(value), do: value

  def author("Tomasz Kowal"), do: ""
  def author(other), do: "by #{other}"
end
