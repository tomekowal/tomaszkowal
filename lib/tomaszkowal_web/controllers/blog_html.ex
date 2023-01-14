defmodule TomaszkowalWeb.BlogView do
  use TomaszkowalWeb, :html

  embed_templates "blog_html/*"

  def color_tags(tags) do
    for(tag <- tags, do: color_tag(tag))
    |> Enum.join()
    |> raw()
  end

  # I like Notion colors https://optemization.com/notion-color-guide
  defp color_tag("nix"), do: "<span style=\"background: #DDEBF1\">nix</span>"
  defp color_tag(other), do: "<span style=\"background: #EBECED\">#{other}</span>"

  # add anchors to allow linking to subheaders
  def postprocess({h, [], [text], %{}}) when h in ["h1", "h2", "h3", "h4", "h5", "h6"] do
    anchor_id = text |> String.downcase() |> String.replace(~r/[^a-z]+/, "-") |> String.trim("-")
    {h, [{"id", anchor_id}], [text], %{}}
  end

  def postprocess(value), do: value
end
