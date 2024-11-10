defmodule PlaygroundWeb.PageLive do
  @moduledoc false
  use PlaygroundWeb, :live_view

  embed_templates "../components/templates/*"

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    {:ok, assign(socket, :theme, params["theme"])}
  end
end
