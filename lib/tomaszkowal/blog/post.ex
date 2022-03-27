defmodule Tomaszkowal.Blog.Post do
  @enforce_keys [:id, :author, :title, :body, :description, :tags, :date, :published]
  defstruct [:id, :author, :title, :body, :description, :tags, :date, :published]

  def build(filename, attrs, body) do
    [year, month_day_id] = filename |> Path.rootname() |> Path.split() |> Enum.take(-2)
    [month, day, id] = String.split(month_day_id, "-", parts: 3)
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")
    struct!(__MODULE__, [id: id, date: date, body: body] ++ Map.to_list(attrs))
  end

  # add anchors to allow linking to subheaders
  def postprocess({h, [], [text], %{}}) when h in ["h1", "h2", "h3", "h4", "h5", "h6"] do
    anchor_id = text |> String.downcase() |> String.replace(~r/[^a-z]+/, "-") |> String.trim("-")
    {h, [{"id", anchor_id}], [text], %{}}
  end

  def postprocess(value), do: value
end
