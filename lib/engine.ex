defmodule SigilA.Engine do
  # %{status: :normal, content: []}
  @behaviour EEx.Engine

  @impl EEx.Engine
  def init(opts) do
    EEx.Engine.init(opts)
    # %{status: :normal, content: []}
  end

  @impl EEx.Engine
  def handle_begin(state) do
    state
    |> IO.inspect(label: ~s{handle_begin(state)})
    |> EEx.Engine.handle_begin()
  end

  @impl EEx.Engine
  def handle_body(state) do
    state
    |> IO.inspect(label: ~s{handle_body(state)})
    |> EEx.Engine.handle_body()
  end

  @impl EEx.Engine
  def handle_end(state) do
    state
    |> IO.inspect(label: ~s{handle_end(state)})
    |> EEx.Engine.handle_end()
  end

  # <%red,bright= world %>

  @impl EEx.Engine
  def handle_expr(state, marker, expr) do
    _ = IO.inspect(marker, label: "MARKER---------------_")
    _ = IO.inspect(expr, label: "EXPRESSION---------------_")

    state
    |> IO.inspect(label: ~s{handle_expr(state, "|", expr)})
    |> EEx.Engine.handle_expr(marker, IO.inspect(expr, label: "expr----"))
  end

  @impl EEx.Engine
  def handle_text(state, text) do
    state
    |> IO.inspect(label: ~s{handle_text(state, text)})
    |> EEx.Engine.handle_text(text)
  end
end
