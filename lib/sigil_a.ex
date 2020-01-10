defmodule SigilA do
  @moduledoc """
  To use:
  ```
  defmodule Foo do
    use SigilA

    def say_hello do
      msg = ~A{Hello, <%red,bright= world %>}
      IO.puts(msg)
    end
  end
  ```
  """

  @escape_group_pattern ~r/<%(?<meta>[a-z_,]*)=(?<content>[^%]*)%>/

  @doc """
  ~A{Hello, <%red,bright= world %>}
  # => [[[[[[], "Hello, "] | "\e[31m"] | "\e[1m"], "world!"] | "\e[0m"]
  """
  defmacro sigil_A(term, modifiers)

  defmacro sigil_A({:<<>>, _meta, [string]}, _modifiers) when is_binary(string) do
    quote do
      tokenized_string = to_ansi(unquote(string))
      IO.ANSI.format(tokenized_string)
    end
  end

  @spec to_ansi(binary) :: maybe_improper_list(any, <<_::24, _::_*8>> | [])
  def to_ansi(string) do
    @escape_group_pattern
    |> Regex.split(string, include_captures: true)
    |> List.foldr([], &parse_raw_tokens/2)
  end

  defp parse_raw_tokens("<%" <> _ = escape_token, acc) do
    @escape_group_pattern
    |> Regex.named_captures(escape_token)
    |> format_escape_group(acc)
  end

  defp parse_raw_tokens(str_token, acc),
    do: [str_token | acc]

  defp format_escape_group(%{"meta" => raw_meta, "content" => raw_content}, acc) do
    content =
      raw_content
      |> String.trim()
      |> List.wrap()

    meta =
      raw_meta
      |> String.split(",")
      |> Enum.map(&String.to_atom/1)

    Enum.concat([meta, content, [:reset], acc])
  end
end
