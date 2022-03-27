defmodule TomaszkowalWeb.Components.Header do
  use Phoenix.Component

  @headers for number <- 1..8, do: :"h#{number}"
  for header <- @headers do
    def unquote(header)(assigns) do
      tag = unquote(header)
      ~H"""
      <#{header} class="text-bold">
      """
    end
  end
end
