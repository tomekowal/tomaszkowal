defmodule TomaszkowalWeb.BlogView do
  use TomaszkowalWeb, :view

  def color_tags(tags) do
    (for tag <- tags, do: color_tag(tag))
    |> Enum.join()
    |> raw()
  end

  # I like Notion colors https://optemization.com/notion-color-guide
  defp color_tag("nix"), do: "<span style=\"background: #DDEBF1\">nix</span>"
  defp color_tag(other), do: "<span style=\"background: #EBECED\">#{other}</span>"
end
